# Sistema de Usuarios — Hot Wheels App (v2 — corregido)

> **Para Hermes:** Usar subagent-driven-development para implementar tarea por tarea.

**Goal:** Añadir sistema completo de usuarios con autenticación multi-proveedor, listas personalizadas, amigos, grupos, deep links para compartir, y pantalla de ajustes.

**Arquitectura:** Supabase Auth (Google, Apple, email; Facebook opcional) → `supabase_flutter` ya integrado. Nuevas tablas en Supabase para perfiles, listas, amistades y grupos. GetX para estado global de sesión. Deep links vía `app_links`.

**Tech Stack:** `supabase_flutter` (auth), `app_links` (deep links, ya incluido), `share_plus` (compartir), GetX (state).

---

## 🔴 Bugs y problemas corregidos del plan original

| # | Problema | Fix |
|---|---------|-----|
| 1 | `list_cars` sin FK real — JOIN feo en 3 columnas | Denormalizar: guardar `image_url`, `series` al añadir coche. JOIN innecesario. |
| 2 | `daily_car` depende de `pg_cron` (no disponible en free tier) | Algoritmo determinista: `hash(date + seed) % total_cars` → sin tabla extra |
| 3 | Falta `group_shared_lists` — no hay forma de compartir lista con grupo | Tabla `group_lists(group_id, list_id)` |
| 4 | `friendships` sin índice en `status` | `CREATE INDEX idx_friendships_status ON friendships(status)` |
| 5 | `auth.currentUser` es null al iniciar (sesión async) | Escuchar `onAuthStateChange` stream en vez de valor puntual |
| 6 | Deep link tras cold start no capturado | Usar `getInitialLink()` al iniciar la app + `linkStream` |
| 7 | Sin middleware para deep links que requieren login | `PendingLinkService` que guarda y re-dispatcha tras login |
| 8 | Share list no auto-pone `is_public = true` | Auto-publicar al compartir (`upsertList` incluye `is_public: true`) |
| 9 | `getUserLists()` sin conteo de coches (N+1) | SQL con subquery: `SELECT *, (SELECT COUNT(*) FROM list_cars WHERE list_id = lists.id) AS car_count` |
| 10 | Clear cache solo evicta imágenes individuales | Usar `PaintingBinding.instance.imageCache.clear()` |
| 11 | Logout no limpia GetX controllers | `AuthController.signOut()` dispara reset de todos los controllers |
| 12 | `search_users` necesita RPC | Crear función `search_profiles(query TEXT)` en SQL |
| 13 | `getFriends()` necesita JOIN complejo | RPC: `get_friends(user_id UUID)` → devuelve perfiles de amigos |
| 14 | Falta poder editar listas (renombrar, visibilidad) | Añadir `updateList(id, name, description, isPublic)` |
| 15 | Deep links con `hotwheels://` no verificables en Android 12+ | Usar universal links con página `.well-known` en sitio web, fallback a custom scheme |

---

## Fase 0 — Preparación Supabase

### Task 0.1: Activar Auth providers
- Supabase Dashboard → Authentication → Providers
- Activar: **Google** (SHA-1 fingerprint necesario para Android), **Apple** (solo iOS, requiere Apple Developer), **Email** (sin verificación for now)
- Facebook: OPCIONAL — requiere Facebook Developer account + app review
- Configurar redirect URLs: `hotwheels://auth/callback` y `https://qbpkcwqwomhyhobnmofy.supabase.co/auth/v1/callback`

### Task 0.2: Ejecutar migración SQL
Ejecutar `migrations/002_user_system.sql` en Supabase SQL Editor.

### Task 0.3: Pubspec
```yaml
dependencies:
  share_plus: ^10.1.4  # añadir
```

---

## Fase 1 — Auth Screen & Session State

### Task 1.1: `AuthController`
**File:** `lib/controllers/auth_controller.dart`

```dart
class AuthController extends GetxController {
  final _client = Supabase.instance.client;
  final user = Rxn<User>();
  final isLoggedIn = false.obs;
  final loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Escuchar cambios de sesión (recuperación async incluida)
    _client.auth.onAuthStateChange.listen((data) {
      user.value = data.session?.user;
      isLoggedIn.value = data.session != null;
      loading.value = false;
      if (data.session != null) _onLogin();
    });
    // Timeout: si en 3s no hay sesión, asumir no logueado
    Future.delayed(const Duration(seconds: 3), () {
      if (loading.value) loading.value = false;
    });
  }

  void _onLogin() {
    Get.find<ListsController>().load();
    // Re-dispatch pending deep link
    Get.find<PendingLinkService>().dispatch();
  }

  Future<void> signInWithGoogle() => _client.auth.signInWithOAuth(OAuthProvider.google);
  Future<void> signInWithApple() => _client.auth.signInWithOAuth(OAuthProvider.apple);
  Future<void> signInWithFacebook() => _client.auth.signInWithOAuth(OAuthProvider.facebook);

  Future<void> signOut() async {
    await _client.auth.signOut();
    // Reset ALL user-scoped controllers
    Get.find<ListsController>().clear();
    Get.find<FriendsController>().clear();
    user.value = null;
    isLoggedIn.value = false;
  }
}
```

### Task 1.2: `LoginScreen` real
**File:** `lib/screens/login_screen.dart`
- Botones: Google (principal), Apple (Platform.isIOS), Email (secundario)
- Diseño: logo Hot Wheels + flames decorativos + botones con iconos de provider
- Si ya logueado → `Get.off(() => ProfileScreen())`

### Task 1.3: Actualizar `main.dart`
- `Get.put(AuthController())` + `Get.put(PendingLinkService())`
- AppBar: `Obx(() => auth.user.value != null ? CircleAvatar(backgroundImage: NetworkImage(auth.user.value!.userMetadata?['avatar_url'] ?? '')) : IconButton(icon: Icon(Icons.person_outline), ...))`

### Task 1.4: `ProfileScreen`
**File:** `lib/screens/profile_screen.dart`
- Avatar, display_name, email
- Stats cards: Lists, Cars saved, Friends
- ListView de opciones: My Lists →, Friends →, Groups →, Settings →
- Botón Logout al fondo (rojo)

---

## Fase 2 — Sistema de Listas

### Task 2.1: Modelos
```dart
// lib/models/user_list.dart
class UserList {
  final String id, userId, name;
  final String? description;
  final bool isPublic;
  final int carCount;  // incluido en la query
  final String? previewImage; // primera imagen de la lista
  final DateTime createdAt;
}
```

### Task 2.2: Queries en `SupabaseService`
Añadir métodos:
- `getUserLists()` → `SELECT *, (SELECT COUNT(*) FROM list_cars WHERE list_id = lists.id) AS car_count FROM lists WHERE user_id = auth.uid() ORDER BY created_at`
- `createList(name, desc, isPublic)` → INSERT
- `updateList(id, name, desc, isPublic)` → UPDATE
- `deleteList(id)` → DELETE (cascade borra list_cars)
- `addCarToList(listId, car)` → INSERT con `image_url` y `series` denormalizados
- `removeCarFromList(listId, carToyNum, carModelName, carYear)` → DELETE
- `getListCars(listId)` → SELECT + JOIN con cars para datos completos
- `getPublicList(listId)` → SELECT con RLS (solo públicas)
- `isCarInAnyList(car)` → booleano rápido para UI

### Task 2.3: `ListsController`
```dart
class ListsController extends GetxController {
  final lists = <UserList>[].obs;
  final loading = false.obs;

  Future<void> load() async { ... }
  Future<void> createList(name, desc) async { ... }
  Future<void> toggleCarInList(listId, car) async { ... }
  bool isCarInList(listId, car) { ... }
  void clear() { lists.clear(); }
}
```

### Task 2.4: `MyListsScreen`
- Grid de tarjetas con preview de 3 imágenes en miniatura
- Chip con conteo de coches
- FAB → diálogo "New List" (nombre, descripción, toggle público)
- Long press → opciones: Rename, Delete, Share
- Tap → `ListDetailScreen`

### Task 2.5: `ListDetailScreen`
- Grid de coches (mismo componente que `CarListScreen`)
- Si es dueño: swipe para quitar, botón share
- Si es visita (deep link): banner "Shared by @user", solo lectura
- Share → auto-publica lista → genera deep link → `Share.share(link)`

### Task 2.6: Botón "Add to List" en `CarDetailScreen`
- Bottom sheet con:
  - Campo "Create new list" al principio (atajo)
  - Lista de listas con Switch/toggle (activado = coche está en esa lista)
  - Vista previa: mini thumbnail del primer coche de cada lista

---

## Fase 3 — Amigos y Grupos

### Task 3.1: Modelos
```dart
// friendship.dart — Friendship(id, requesterId, addresseeId, status, createdAt, otherUser)
// group.dart — Group(id, name, description, ownerId, memberCount, createdAt)
```

### Task 3.2: RPCs SQL
```sql
-- Buscar usuarios
CREATE OR REPLACE FUNCTION search_profiles(query TEXT)
RETURNS TABLE(id UUID, display_name TEXT, avatar_url TEXT) AS $$
BEGIN
  RETURN QUERY SELECT p.id, p.display_name, p.avatar_url
  FROM profiles p WHERE p.display_name ILIKE '%' || query || '%' LIMIT 20;
END; $$ LANGUAGE plpgsql;

-- Obtener amigos (con perfiles)
CREATE OR REPLACE FUNCTION get_friends(user_id UUID)
RETURNS TABLE(friendship_id UUID, friend_id UUID, display_name TEXT, avatar_url TEXT) AS $$
BEGIN
  RETURN QUERY
    SELECT f.id, p.id, p.display_name, p.avatar_url
    FROM friendships f
    JOIN profiles p ON p.id = CASE WHEN f.requester_id = user_id THEN f.addressee_id ELSE f.requester_id END
    WHERE (f.requester_id = user_id OR f.addressee_id = user_id) AND f.status = 'accepted';
END; $$ LANGUAGE plpgsql;
```

### Task 3.3: `FriendsController`
- `friends`, `pendingRequests`, `searchResults`
- `searchUsers(q)`, `sendRequest(id)`, `acceptRequest(id)`, `rejectRequest(id)`

### Task 3.4: `FriendsScreen`
- 2 tabs: Friends | Pending (badge con count)
- Friends: ListTile con avatar + nombre → tap abre perfil del amigo
- Pending: botones Accept / Decline
- Search FAB → buscar usuario → enviar solicitud

### Task 3.5: `GroupsScreen` + `GroupDetailScreen`
- Groups: lista de grupos con member count
- Group Detail: miembros, listas compartidas, añadir miembros, compartir lista
- Solo el owner puede añadir miembros y compartir listas

---

## Fase 4 — Deep Links

### Task 4.1: Configuración nativa
**AndroidManifest.xml:**
```xml
<intent-filter android:autoVerify="true">
  <action android:name="android.intent.action.VIEW"/>
  <category android:name="android.intent.category.DEFAULT"/>
  <category android:name="android.intent.category.BROWSABLE"/>
  <data android:scheme="https" android:host="hotwheels.app" android:pathPrefix="/list/"/>
</intent-filter>
```

**Info.plist:** Añadir `hotwheels` URL scheme + associated domain `applinks:hotwheels.app`

### Task 4.2: `DeepLinkService`
```dart
class DeepLinkService {
  final _appLinks = AppLinks();

  Future<void> init() async {
    // Link inicial (cold start)
    final initial = await _appLinks.getInitialLink();
    if (initial != null) handle(initial);

    // Links en caliente
    _appLinks.uriLinkStream.listen(handle);
  }

  void handle(Uri uri) {
    if (uri.pathSegments.first == 'list' && uri.pathSegments.length == 2) {
      final listId = uri.pathSegments[1];
      if (AuthController.to.isLoggedIn.value) {
        Get.to(() => ListDetailScreen(listId: listId));
      } else {
        Get.find<PendingLinkService>().pending = uri;
      }
    }
  }
}
```

### Task 4.3: `PendingLinkService`
- Guarda el URI pendiente
- Tras login exitoso, `dispatch()` → navega al link pendiente

### Task 4.4: Share
```dart
// En ListDetailScreen
final link = 'https://hotwheels.app/list/$listId';
await Share.share('Check out my Hot Wheels list: $link', subject: list.name);
```

---

## Fase 5 — Settings

### Task 5.1: `SettingsScreen`
- **Account**: Edit display name, Change password (Supabase `reauthenticate()`)
- **App**: Clear cache → `PaintingBinding.instance.imageCache.clear()` + `CachedNetworkImage.evictFromCache()` + snackbar "Cache cleared"
- **Danger Zone**: Delete account → confirmación → `_client.auth.admin.deleteUser()` o RPC
- **About**: Version (desde `package_info_plus`), Privacy Policy, Licenses

---

## Fase 6 — Mejoras (nice-to-have)

### Task 6.1: Favoritos
- Tabla `favorites` con campos denormalizados (`image_url`, `series`)
- Icono ❤️ en `CarDetailScreen` y esquina de tarjetas en `CarListScreen`
- Sección "Favorites" en `ProfileScreen`

### Task 6.2: Coche del día (determinista, sin pg_cron)
```dart
Future<HotWheelsCar> getDailyCar() async {
  final today = DateTime.now().toIso8601String().substring(0, 10);
  final seed = today.hashCode.abs();
  final count = await getCarCount();
  final offset = seed % count;
  return getCarByOffset(offset);
}
```
- Widget "Car of the Day 🔥" en HomeScreen con diseño destacado (borde dorado, badge)

### Task 6.3: Historial
- Guardar en `view_history` al abrir `CarDetailScreen`
- Widget "Recently viewed" en HomeScreen

---

## SQL final: `migrations/002_user_system.sql`

```sql
-- Profiles
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, display_name, avatar_url)
    VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email), NEW.raw_user_meta_data->>'avatar_url');
    RETURN NEW;
END; $$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Lists
CREATE TABLE lists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- List cars (junction, denormalized)
CREATE TABLE list_cars (
    list_id UUID REFERENCES lists(id) ON DELETE CASCADE,
    car_year INT NOT NULL,
    car_toy_num TEXT NOT NULL,
    car_model_name TEXT NOT NULL,
    car_image_url TEXT,
    car_series TEXT,
    added_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (list_id, car_year, car_toy_num, car_model_name)
);

-- Friendships
CREATE TABLE friendships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    requester_id UUID NOT NULL REFERENCES profiles(id),
    addressee_id UUID NOT NULL REFERENCES profiles(id),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(requester_id, addressee_id)
);

-- Groups
CREATE TABLE groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    owner_id UUID NOT NULL REFERENCES profiles(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE group_members (
    group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (group_id, user_id)
);

-- Group shared lists
CREATE TABLE group_lists (
    group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
    list_id UUID REFERENCES lists(id) ON DELETE CASCADE,
    shared_by UUID REFERENCES profiles(id),
    shared_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (group_id, list_id)
);

-- Favorites (denormalized)
CREATE TABLE favorites (
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    car_year INT NOT NULL,
    car_toy_num TEXT NOT NULL,
    car_model_name TEXT NOT NULL,
    car_image_url TEXT,
    car_series TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, car_year, car_toy_num, car_model_name)
);

-- View history
CREATE TABLE view_history (
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    car_year INT NOT NULL,
    car_toy_num TEXT NOT NULL,
    car_model_name TEXT NOT NULL,
    car_image_url TEXT,
    car_series TEXT,
    viewed_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, car_year, car_toy_num, car_model_name)
);

-- RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE list_cars ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE view_history ENABLE ROW LEVEL SECURITY;

-- profiles: readable by all, writable by owner
CREATE POLICY p_profiles_select ON profiles FOR SELECT USING (true);
CREATE POLICY p_profiles_update ON profiles FOR UPDATE USING (auth.uid() = id);

-- lists: owner full access, public readable
CREATE POLICY p_lists_select ON lists FOR SELECT USING (auth.uid() = user_id OR is_public = true);
CREATE POLICY p_lists_insert ON lists FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY p_lists_update ON lists FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY p_lists_delete ON lists FOR DELETE USING (auth.uid() = user_id);

-- list_cars: follows list permissions
CREATE POLICY p_list_cars_select ON list_cars FOR SELECT USING (
    EXISTS (SELECT 1 FROM lists WHERE id = list_id AND (user_id = auth.uid() OR is_public = true))
);
CREATE POLICY p_list_cars_insert ON list_cars FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM lists WHERE id = list_id AND user_id = auth.uid())
);
CREATE POLICY p_list_cars_delete ON list_cars FOR DELETE USING (
    EXISTS (SELECT 1 FROM lists WHERE id = list_id AND user_id = auth.uid())
);

-- friendships
CREATE POLICY p_friendships_select ON friendships FOR SELECT USING (auth.uid() IN (requester_id, addressee_id));
CREATE POLICY p_friendships_insert ON friendships FOR INSERT WITH CHECK (auth.uid() = requester_id);
CREATE POLICY p_friendships_update ON friendships FOR UPDATE USING (auth.uid() = addressee_id);

-- groups
CREATE POLICY p_groups_select ON groups FOR SELECT USING (
    EXISTS (SELECT 1 FROM group_members WHERE group_id = groups.id AND user_id = auth.uid())
);
CREATE POLICY p_groups_insert ON groups FOR INSERT WITH CHECK (auth.uid() = owner_id);
CREATE POLICY p_groups_delete ON groups FOR DELETE USING (auth.uid() = owner_id);

-- group_members
CREATE POLICY p_group_members_select ON group_members FOR SELECT USING (
    EXISTS (SELECT 1 FROM group_members gm WHERE gm.group_id = group_members.group_id AND gm.user_id = auth.uid())
);
CREATE POLICY p_group_members_insert ON group_members FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM groups WHERE id = group_members.group_id AND owner_id = auth.uid())
);

-- group_lists: visible to group members
CREATE POLICY p_group_lists_select ON group_lists FOR SELECT USING (
    EXISTS (SELECT 1 FROM group_members WHERE group_id = group_lists.group_id AND user_id = auth.uid())
);
CREATE POLICY p_group_lists_insert ON group_lists FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM group_members WHERE group_id = group_lists.group_id AND user_id = auth.uid())
);

-- favorites: user-only
CREATE POLICY p_favorites_select ON favorites FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY p_favorites_insert ON favorites FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY p_favorites_delete ON favorites FOR DELETE USING (auth.uid() = user_id);

-- view_history: user-only
CREATE POLICY p_history_select ON view_history FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY p_history_insert ON view_history FOR INSERT WITH CHECK (auth.uid() = user_id);

-- RPCs
CREATE OR REPLACE FUNCTION search_profiles(query TEXT)
RETURNS TABLE(id UUID, display_name TEXT, avatar_url TEXT) AS $$
BEGIN
  RETURN QUERY SELECT p.id, p.display_name, p.avatar_url
  FROM profiles p WHERE p.display_name ILIKE '%' || query || '%' LIMIT 20;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_friends(p_user_id UUID)
RETURNS TABLE(friendship_id UUID, friend_id UUID, display_name TEXT, avatar_url TEXT) AS $$
BEGIN
  RETURN QUERY
    SELECT f.id, p.id, p.display_name, p.avatar_url
    FROM friendships f
    JOIN profiles p ON p.id = CASE WHEN f.requester_id = p_user_id THEN f.addressee_id ELSE f.requester_id END
    WHERE (f.requester_id = p_user_id OR f.addressee_id = p_user_id) AND f.status = 'accepted';
END; $$ LANGUAGE plpgsql;

-- Indexes
CREATE INDEX idx_lists_user ON lists(user_id);
CREATE INDEX idx_list_cars_list ON list_cars(list_id);
CREATE INDEX idx_friendships_requester ON friendships(requester_id);
CREATE INDEX idx_friendships_addressee ON friendships(addressee_id);
CREATE INDEX idx_friendships_status ON friendships(status);
CREATE INDEX idx_group_members_user ON group_members(user_id);
CREATE INDEX idx_group_lists_group ON group_lists(group_id);
CREATE INDEX idx_favorites_user ON favorites(user_id);
CREATE INDEX idx_view_history_user ON view_history(user_id);
CREATE INDEX idx_view_history_viewed ON view_history(user_id, viewed_at DESC);
```

---

## Estructura final de archivos

```
hot_wheels/lib/
├── main.dart
├── theme/hw_theme.dart
├── controllers/
│   ├── filter_controller.dart
│   ├── app_controllers.dart
│   ├── auth_controller.dart          # NUEVO
│   ├── lists_controller.dart         # NUEVO
│   └── friends_controller.dart       # NUEVO
├── models/
│   ├── hot_wheels_car.dart
│   ├── user_list.dart                # NUEVO
│   ├── friendship.dart               # NUEVO
│   └── group.dart                    # NUEVO
├── screens/
│   ├── home_screen.dart              # actualizado
│   ├── car_list_screen.dart          # actualizado (fav icon)
│   ├── car_detail_screen.dart        # actualizado (add to list + fav)
│   ├── filter_screen.dart
│   ├── brand_list_screen.dart
│   ├── series_list_screen.dart
│   ├── login_screen.dart             # REESCRITO
│   ├── profile_screen.dart           # NUEVO
│   ├── settings_screen.dart          # NUEVO
│   ├── my_lists_screen.dart          # NUEVO
│   ├── list_detail_screen.dart       # NUEVO
│   ├── friends_screen.dart           # NUEVO
│   ├── groups_screen.dart            # NUEVO
│   └── group_detail_screen.dart      # NUEVO
└── services/
    ├── supabase_service.dart         # extendido
    ├── deep_link_service.dart        # NUEVO
    └── pending_link_service.dart     # NUEVO
```

---

## Orden de implementación

| Fase | Descripción | Prioridad |
|------|------------|:---------:|
| 0 | SQL migration + Auth providers en Supabase | 🔴 |
| 1 | Auth screen + AuthController + sesión + perfil | 🔴 |
| 2 | Sistema de listas (CRUD, add to list, share) | 🟡 |
| 3 | Amigos y grupos (con RPCs SQL) | 🟢 |
| 4 | Deep links + pending link + share sheet | 🟢 |
| 5 | Settings (logout, clear cache, account) | 🟡 |
| 6 | Favoritos, coche del día, historial | 🔵 |

---

# Fase 7 — UX: Diálogos, Errores, Loading States

> Esta fase es transversal: define los patrones que TODAS las pantallas deben seguir.

---

## 7.1 — Diálogos de "Inicia sesión para..."

**Regla:** La app NUNCA bloquea al usuario. Si no está logueado, puede navegar todo. Solo al intentar una acción protegida se muestra un diálogo invitando a iniciar sesión.

### Componente reutilizable: `AuthGate`

```dart
// lib/widgets/auth_gate.dart
class AuthGate {
  /// Ejecuta [action] si el usuario está logueado.
  /// Si no, muestra un diálogo persuasivo.
  static Future<void> guard(BuildContext context, {
    required String feature,      // "save cars to lists"
    required String benefit,      // "create collections and share them"
    required VoidCallback action,
  }) async {
    final auth = Get.find<AuthController>();
    if (auth.isLoggedIn.value) {
      action();
      return;
    }

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: HwTheme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(Icons.lock_outline, color: HwTheme.orange, size: 48),
        title: Text('Sign in to $feature', style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(benefit, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            _BenefitRow(Icons.bookmark, 'Save cars to custom lists'),
            _BenefitRow(Icons.share, 'Share collections with friends'),
            _BenefitRow(Icons.people, 'Join groups and discover cars'),
            _BenefitRow(Icons.favorite, 'Favorite your dream cars'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Later', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); Get.to(() => const LoginScreen()); },
            style: ElevatedButton.styleFrom(backgroundColor: HwTheme.orange),
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }

  static Widget _BenefitRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Icon(icon, color: HwTheme.orange, size: 18),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13))),
    ]),
  );
}
```

### Puntos de uso

| Pantalla | Acción | `feature` | `benefit` |
|----------|--------|-----------|-----------|
| CarDetailScreen | Add to list | "save cars to lists" | "create collections and share with friends" |
| CarDetailScreen | Favorite | "favorite cars" | "build your dream garage wishlist" |
| CarListScreen | Favorite (icono tarjeta) | "favorite cars" | "build your dream garage wishlist" |
| MyListsScreen | Create list | "create lists" | "organize your Hot Wheels collection" |
| HomeScreen | Profile icon | — | redirige directo a LoginScreen si no logueado |
| Deep link (shared list) | — | sin bloquear | banner "Sign in to save this list" |

### Banner en listas compartidas (visitante)

Cuando un usuario no logueado abre una lista compartida vía deep link, en vez de bloquear, se muestra un banner sutil:

```dart
// En ListDetailScreen (modo visita)
if (!auth.isLoggedIn.value)
  Container(
    padding: EdgeInsets.all(12),
    color: HwTheme.orange.withOpacity(0.1),
    child: Row(children: [
      Icon(Icons.info_outline, color: HwTheme.orange),
      SizedBox(width: 8),
      Expanded(child: Text('Sign in to save this list or create your own', style: TextStyle(color: HwTheme.orange))),
      TextButton(onPressed: () => Get.to(() => LoginScreen()), child: Text('Sign in', style: TextStyle(color: HwTheme.orange))),
    ]),
  )
```

---

## 7.2 — Gestión de errores

### Jerarquía de errores

| Nivel | Tipo | UI | Ejemplos |
|-------|------|----|---------|
| 🔴 **Crítico** | Conexión perdida, auth fallida | Full-screen error con retry | `SupabaseException`, timeout |
| 🟡 **Operación** | Acción fallida (add to list, delete) | Snackbar con mensaje + retry | RLS violation, duplicado |
| 🟢 **Informativo** | Validación, aviso | Snackbar breve | "Name is required", "List created" |

### Componente: `AppError`

```dart
// lib/widgets/app_error.dart
class AppError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final bool fullScreen;

  const AppError({
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.fullScreen = false,
  });

  factory AppError.fullScreen(String message, {VoidCallback? onRetry}) =>
    AppError(message: message, onRetry: onRetry, fullScreen: true);

  factory AppError.snackbar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade900, colorText: Colors.white);
    return AppError(message: message); // dummy, snackbar ya mostrado
  }

  @override
  Widget build(BuildContext context) {
    if (!fullScreen) return const SizedBox.shrink();
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: HwTheme.flame, size: 48),
      const SizedBox(height: 12),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70))),
      if (onRetry != null) ...[const SizedBox(height: 16),
        ElevatedButton(onPressed: onRetry, child: const Text('Retry'))],
    ]));
  }
}
```

### Mapeo de excepciones Supabase → mensajes de usuario

```dart
// lib/services/error_handler.dart
class ErrorHandler {
  static String humanize(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('duplicate') || msg.contains('23505')) return 'This item already exists';
    if (msg.contains('violates row-level security')) return 'You don\'t have permission';
    if (msg.contains('jwt expired') || msg.contains('401')) return 'Session expired. Please sign in again.';
    if (msg.contains('timeout') || msg.contains('connection')) return 'No internet connection. Check your network.';
    if (msg.contains('user already registered')) return 'An account with this email already exists';
    if (msg.contains('invalid login credentials')) return 'Incorrect email or password';
    if (msg.contains('422')) return 'Please check your input and try again';
    return 'Something went wrong. Please try again.'; // fallback genérico
  }

  static void show(Object error, {VoidCallback? onRetry}) {
    final msg = humanize(error);
    if (onRetry != null) {
      Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade900, colorText: Colors.white,
        mainButton: TextButton(onPressed: onRetry, child: const Text('Retry', style: TextStyle(color: Colors.white))));
    } else {
      AppError.snackbar(msg);
    }
  }
}
```

### Patrón try/catch estándar en controllers

```dart
// Ejemplo en ListsController
Future<void> createList(String name, String desc) async {
  loading.value = true;
  try {
    await _service.createList(name, desc);
    await load(); // refrescar
    Get.snackbar('Success', 'List "$name" created', snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade900, colorText: Colors.white);
  } catch (e) {
    ErrorHandler.show(e);
  } finally {
    loading.value = false;
  }
}
```

### Errores específicos que pueden ocurrir

| Operación | Posible error | Manejo |
|-----------|-------------|--------|
| Google Sign-In | Usuario cancela → `AbortedException` | Ignorar (no mostrar error) |
| Google Sign-In | SHA-1 no configurado | Snackbar: "Google Sign-In not configured. Use email instead." |
| Email login | Credenciales inválidas | Snackbar específico: "Incorrect email or password" |
| Add to list | RLS (lista no es del usuario) | Snackbar: "You can only add to your own lists" |
| Delete list | Cascade falla | Snackbar con retry |
| Share list | `Share.share()` falla | Ignorar (nativo maneja) |
| Deep link | Lista borrada → 404 | Full-screen: "This list is no longer available" |
| Deep link | Lista privada → RLS | Full-screen: "This list is private" |
| Friend request | Ya enviada → duplicate | Snackbar: "Request already sent" |
| Friend request | A uno mismo | Snackbar: "You can't send a friend request to yourself" |

---

## 7.3 — Loading States

### Reglas

1. **Primera carga** → `CircularProgressIndicator` centrado (pantalla completa)
2. **Recargas** → pull-to-refresh (`RefreshIndicator`) + shimmer opcional
3. **Botones** → `isLoading` desactiva el botón y muestra spinner dentro
4. **Imágenes** → `CachedNetworkImage` con placeholder (ya implementado)
5. **Nunca** dos loaders simultáneos visibles

### Componente: `AppLoader`

```dart
// lib/widgets/app_loader.dart
class AppLoader extends StatelessWidget {
  final String? message;
  const AppLoader({this.message});

  @override
  Widget build(BuildContext context) => Center(child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const CircularProgressIndicator(color: HwTheme.orange),
      if (message != null) ...[const SizedBox(height: 12),
        Text(message!, style: const TextStyle(color: Colors.white54))],
    ],
  ));
}
```

### Componente: `LoadingButton`

```dart
// lib/widgets/loading_button.dart
class LoadingButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? color;

  const LoadingButton({required this.label, required this.isLoading, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: isLoading ? null : onPressed,
    style: ElevatedButton.styleFrom(backgroundColor: color ?? HwTheme.orange, minimumSize: const Size(120, 44)),
    child: isLoading
        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
        : Text(label),
  );
}
```

### Pull-to-refresh

Todas las pantallas con listas deben usar `RefreshIndicator`:

```dart
RefreshIndicator(
  onRefresh: () => controller.load(),
  color: HwTheme.orange,
  child: ListView.builder(...),
)
```

### Estados de pantalla unificados

Cada pantalla debe manejar 4 estados. Usar este patrón en TODAS las pantallas:

```dart
Obx(() {
  if (controller.loading.value && controller.items.isEmpty)
    return const AppLoader(message: 'Loading...');
  if (controller.error.value != null)
    return AppError.fullScreen(controller.error.value!, onRetry: () => controller.load());
  if (controller.items.isEmpty)
    return _buildEmpty();
  return _buildContent();
})
```

| Estado | UI | Cuándo |
|--------|----|--------|
| `loading && vacío` | `AppLoader` | Primera carga |
| `error` | `AppError.fullScreen` | Fallo de red / DB |
| `vacío` | Icono + mensaje contextual | Sin datos |
| `datos` | Contenido normal | Éxito |

### Mensajes de "vacío" contextuales

| Pantalla | Mensaje |
|----------|---------|
| My Lists | "No lists yet. Tap + to create your first list!" |
| Friends | "No friends yet. Search for users to connect!" |
| Groups | "No groups yet. Create one to share lists!" |
| Search results | "No cars match your filters" |
| Favorites | "No favorites yet. Tap ♡ on any car!" |

---

## 7.4 — Snackbars de éxito

Patrón consistente para acciones exitosas:

```dart
// lib/widgets/app_snackbar.dart
class AppSnackbar {
  static void success(String message) => Get.snackbar(
    'Success', message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green.shade900,
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    icon: const Icon(Icons.check_circle, color: Colors.white),
  );

  static void info(String message) => Get.snackbar(
    'Info', message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: HwTheme.surface,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
  );
}
```

---

## 7.5 — Confirmaciones (diálogos de delete)

```dart
// lib/widgets/confirm_dialog.dart
class ConfirmDialog {
  static Future<bool> show(BuildContext context, {required String title, required String message, String confirmText = 'Delete', Color confirmColor = Colors.red}) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: HwTheme.card,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: Colors.white38))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(confirmText, style: TextStyle(color: confirmColor))),
        ],
      ),
    ) ?? false;
  }
}
```

Casos de uso:
- Delete list → "Delete list?" / "This will remove all cars from this list. This action cannot be undone."
- Remove friend → "Remove friend?" / "You'll need to send a new request to reconnect."
- Delete account → "Delete account?" / "All your data will be permanently deleted."

---

## 7.6 — Edge cases adicionales

| Caso | Manejo |
|------|--------|
| User cierra sesión viendo lista | `AuthController.signOut()` navega a HomeScreen y limpia controllers |
| Sesión expira (JWT) | `onAuthStateChange` detecta `null` → snackbar "Session expired" + volver a home |
| Deep link a lista borrada | `getPublicList` devuelve null → `AppError.fullScreen('This list is no longer available')` |
| Doble tap en botón | `LoadingButton` desactiva `onPressed` mientras `isLoading = true` |
| Sin conexión | Supabase lanza `TimeoutException` → `ErrorHandler` muestra "No internet" |
| Lista vacía al compartir | Desactivar botón share si `list_cars` está vacío |
| Emulador sin Google Play Services | Google Sign-In falla → snackbar específico + sugerir email login |
| Notificaciones push sin permiso | No bloquear, simplemente no enviar |

---

# Fase 8 — Sistema de Theming (Light + Dark)

> **Principio:** CERO colores hardcodeados en widgets. Todo pasa por `Theme.of(context)`.
> El usuario cambia entre light/dark desde Settings. La preferencia se persiste con `SharedPreferences` (o Supabase `user_metadata` si está logueado).

---

## 8.1 — Arquitectura del tema

### `HwTheme` reescrito

```dart
// lib/theme/hw_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HwTheme {
  // Constantes de color que NO cambian entre modos (marca)
  static const brandOrange = Color(0xFFFF6B00);
  static const brandFlame = Color(0xFFFF3D00);
  static const brandBlue = Color(0xFF0066CC);

  HwTheme._(); // no instanciable

  // ── Light Theme ──

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F7),
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandOrange,
      brightness: Brightness.light,
      primary: brandOrange,
      secondary: brandBlue,
      error: brandFlame,
      surface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 1,
      titleTextStyle: GoogleFonts.bebasNeue(fontSize: 26, color: const Color(0xFF1A1A1A), letterSpacing: 1),
      iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      titleLarge: GoogleFonts.bebasNeue(fontSize: 28, color: const Color(0xFF1A1A1A)),
      titleMedium: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A)),
      bodyMedium: GoogleFonts.roboto(color: const Color(0xFF666666)),
      bodySmall: GoogleFonts.roboto(color: const Color(0xFF999999)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFEEEEEE),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
    dividerColor: const Color(0xFFE0E0E0),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFEEEEEE),
      selectedColor: brandOrange.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // ── Dark Theme ──

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandOrange,
      brightness: Brightness.dark,
      primary: brandOrange,
      secondary: brandBlue,
      error: brandFlame,
      surface: const Color(0xFF1A1A2E),
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1A2E),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.bebasNeue(fontSize: 26, color: Colors.white, letterSpacing: 1),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF16213E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
      titleLarge: GoogleFonts.bebasNeue(fontSize: 28, color: Colors.white),
      titleMedium: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Colors.white),
      bodyMedium: GoogleFonts.roboto(color: Colors.white70),
      bodySmall: GoogleFonts.roboto(color: Colors.white38),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1A2E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      hintStyle: const TextStyle(color: Colors.white38),
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Color(0xFF1A1A2E)),
    dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF16213E)),
    dividerColor: Colors.white12,
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1A1A2E),
      selectedColor: brandOrange.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  // ── Acceso rápido a colores desde el contexto (para casos inevitables) ──

  /// Color naranja de marca (igual en ambos modos)
  static Color orange(BuildContext context) => Theme.of(context).colorScheme.primary;

  /// Color de superficie/background de cards
  static Color surface(BuildContext context) => Theme.of(context).colorScheme.surface;

  /// Color de fondo de pantalla
  static Color background(BuildContext context) => Theme.of(context).scaffoldBackgroundColor;

  /// Texto primario (negro en light, blanco en dark)
  static Color textPrimary(BuildContext context) => Theme.of(context).colorScheme.onSurface;

  /// Texto secundario (gris en light, gris claro en dark)
  static Color textSecondary(BuildContext context) => Theme.of(context).textTheme.bodyMedium!.color!;

  /// Borde sutil
  static Color border(BuildContext context) => Theme.of(context).dividerColor;
}
```

### `ThemeController` (GetX)

```dart
// lib/controllers/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/hw_theme.dart';

class ThemeController extends GetxController {
  final isDark = true.obs; // default: dark (HW brand)

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    isDark.value = prefs.getBool('theme_dark') ?? true;
    Get.changeTheme(isDark.value ? HwTheme.dark : HwTheme.light);
  }

  Future<void> toggle() async {
    isDark.toggle();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_dark', isDark.value);
    Get.changeTheme(isDark.value ? HwTheme.dark : HwTheme.light);
  }
}
```

### Actualización de `main.dart`

```dart
Get.put(ThemeController());  // antes de GetMaterialApp

return GetMaterialApp(
  theme: HwTheme.light,
  darkTheme: HwTheme.dark,
  themeMode: ThemeMode.system,  // o controller-driven
  ...
);
```

**Alternativa más simple** (control manual, no system):
```dart
return GetMaterialApp(
  theme: HwTheme.dark,
  home: const HomeScreen(),
);
```
Y en Settings toggle → `Get.changeTheme(HwTheme.light/HwTheme.dark)`.

---

## 8.2 — Migración de widgets existentes

### Regla de migración

| Antes (hardcodeado) | Después (theme-aware) |
|---------------------|----------------------|
| `Color(0xFF0D0D0D)` | `Theme.of(context).scaffoldBackgroundColor` |
| `Color(0xFF1A1A2E)` | `Theme.of(context).colorScheme.surface` |
| `Color(0xFF16213E)` | `Theme.of(context).cardTheme.color` |
| `Colors.white` | `Theme.of(context).colorScheme.onSurface` |
| `Colors.white70` | `Theme.of(context).textTheme.bodyMedium!.color` |
| `Colors.white38` | `Theme.of(context).textTheme.bodySmall!.color` |
| `Colors.white12` | `Theme.of(context).dividerColor` |
| `Colors.orange` | `Theme.of(context).colorScheme.primary` |
| `HwTheme.orange` | `Theme.of(context).colorScheme.primary` |
| `HwTheme.card` | `Theme.of(context).cardTheme.color` |
| `HwTheme.surface` | `Theme.of(context).colorScheme.surface` |
| `HwTheme.textDim` | `Theme.of(context).textTheme.bodySmall!.color` |

### Archivos a migrar (14 archivos)

| Archivo | Cambios necesarios |
|---------|-------------------|
| `home_screen.dart` | section titles, card backgrounds, gradient year cards (keep gradient), chip colors |
| `car_list_screen.dart` | card backgrounds, text colors, variant badge |
| `car_detail_screen.dart` | background, text, series chip |
| `filter_screen.dart` | input fill, dropdown colors, card colors |
| `brand_list_screen.dart` | card, text, grid items |
| `series_list_screen.dart` | card, text, grid items |
| `login_screen.dart` | background, text |
| `search_screen.dart` | card, text |
| `auth_gate.dart` (nuevo) | dialog background |
| `app_error.dart` (nuevo) | text, button |
| `app_loader.dart` (nuevo) | text |
| `confirm_dialog.dart` (nuevo) | dialog background |
| `loading_button.dart` (nuevo) | button style |

### Ejemplo de migración: car_list_screen.dart

```dart
// ANTES
Container(
  decoration: BoxDecoration(
    color: HwTheme.card,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.white12),
  ),
  child: Text(car.modelName, style: TextStyle(fontSize: 10, color: Colors.white)),
)

// DESPUÉS
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).cardTheme.color,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Theme.of(context).dividerColor),
  ),
  child: Text(car.modelName, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface)),
)
```

### Patrón para evitar repetir `Theme.of(context)`

En widgets grandes, extraer al inicio del build:

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;
  final text = theme.textTheme;

  return Container(
    color: cs.surface,   // en vez de Theme.of(context).colorScheme.surface
    child: Text('Hello', style: text.bodyMedium),
  );
}
```

### Nota sobre gradientes

Los gradientes (como las tarjetas de año con `LinearGradient(colors: [orange, flame])`) deben mantenerse con los colores de marca (`HwTheme.brandOrange`, `HwTheme.brandFlame`) porque son identidad visual, no fondo adaptativo.

---

## 8.3 — Settings: toggle de tema

En `SettingsScreen`, añadir:

```dart
// Sección Appearance
SwitchListTile(
  title: const Text('Dark mode'),
  subtitle: const Text('Switch between light and dark appearance'),
  value: themeController.isDark.value,
  onChanged: (_) => themeController.toggle(),
  activeColor: HwTheme.brandOrange,  // color de marca, no adaptativo
  secondary: const Icon(Icons.dark_mode),
)
```

Opcional: RadioListTile con 3 opciones (Light / Dark / System).

---

## 8.4 — Paquete necesario

```yaml
dependencies:
  shared_preferences: ^2.3.0  # para persistir preferencia de tema
```

---

## 8.5 — Lo que todavía NO está planificado

### Pendientes detectados en revisión global

| # | Qué falta | Dónde iría |
|---|----------|-----------|
| 1 | **Onboarding** — 3 slides explicando la app al primer launch | Nueva pantalla `onboarding_screen.dart` + `shared_preferences` flag `onboarding_done` |
| 2 | **Empty states con CTA** — cuando una pantalla está vacía, mostrar botón de acción (ej: "Create your first list") en vez de solo texto | Todas las pantallas de lista (my lists, friends, groups, favorites) |
| 3 | **Skeleton loaders** — shimmer effect mientras carga (mejor UX que spinner solo) | Paquete `shimmer` + widget `SkeletonCard` |
| 4 | **Animaciones de transición** entre pantallas (GetX tiene `Get.to(() => ..., transition: Transition.rightToLeft)`) | Navegación global |
| 5 | **Haptic feedback** en acciones importantes (add to list, favorite, delete) | `HapticFeedback.lightImpact()` en callbacks |
| 6 | **Accesibilidad** — `Semantics` labels en iconos, contraste suficiente en light mode | Todos los widgets con iconos sin texto |
| 7 | **Localización** — soporte español/inglés (`flutter_localizations`) | `lib/l10n/` + `MaterialApp.localizationsDelegates` |
| 8 | **Analytics** — eventos básicos (screen views, actions) para entender uso | Supabase `analytics` o `firebase_analytics` (opcional) |
| 9 | **App icon** — icono personalizado Hot Wheels (el default es el de Flutter) | `flutter_launcher_icons` + asset 1024x1024 |
| 10 | **Splash screen** — pantalla de carga con logo mientras inicializa | `flutter_native_splash` |
| 11 | **Tutorial contextual** — tooltips en primera visita explicando features | `shared_preferences` flag + `showDialog` con highlight |
| 12 | **Feedback in-app** — botón "Send feedback" en Settings | Abre email o usa servicio externo |
| 13 | **Rate app** — prompt después de N días / N acciones | `in_app_review` o `rate_my_app` |
| 14 | **Offline mode** — cachear datos básicos para cuando no hay conexión | `shared_preferences` + `cached_network_image` (ya está) |
| 15 | **Migración de DB** — versión de schema para futuras actualizaciones | Tabla `schema_version` en Supabase |
| 16 | **Tests** — widget tests, integration tests | `test/` directory |
| 17 | **CI/CD** — GitHub Action para correr `flutter analyze` y `flutter test` en cada PR | `.github/workflows/flutter.yml` |
| 18 | **Fastlane** — automatizar build y deploy a Play Store / App Store | `fastlane/` directory |

---

## Orden de prioridad actualizado

| # | Qué | Prioridad |
|---|-----|:---------:|
| 0 | SQL migration + Supabase Auth providers | 🔴 |
| 1 | Auth screen + AuthController + sesión | 🔴 |
| 1.5 | **Sistema de theming (light/dark) + migración widgets** | 🔴 |
| 2 | Sistema de listas | 🟡 |
| 3 | Amigos y grupos | 🟢 |
| 4 | Deep links + share | 🟢 |
| 5 | Settings (incluye toggle tema) | 🟡 |
| 6 | Favoritos, coche del día, historial | 🔵 |
| 7 | Widgets UX (auth gate, errores, loaders, diálogos) | 🔴 |
| 8 | Onboarding + splash screen + app icon | 🟡 |
| 9 | Skeleton loaders + animaciones | 🟢 |
| 10 | Localización (es/en) | 🟢 |
| 11 | Tests + CI/CD | 🔵 |
| 12 | Analytics + feedback + rate app | 🔵 |


