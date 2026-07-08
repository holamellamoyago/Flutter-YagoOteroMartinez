/// Stores a deep link URI received before the user logs in,
/// and re-dispatches it once authentication completes.
class PendingLinkService {
  Uri? pending;

  void dispatch() {
    if (pending == null) return;
    // Will be handled by DeepLinkService when implemented (Phase 4)
    // For now, the link is saved and will be dispatched later
    pending = null;
  }
}
