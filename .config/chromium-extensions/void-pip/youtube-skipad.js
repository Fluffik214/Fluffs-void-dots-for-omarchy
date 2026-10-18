// Runs in YouTube's own page context from document start. While an ad plays,
// the PiP card's ⏭ (next track) button skips the ad; afterwards it goes back
// to whatever YouTube had there. Chromium's PiP doesn't draw a "skipad"
// button yet, so that action is registered too in case a later version does.
(() => {
  const session = navigator.mediaSession;
  if (!session) return;

  const setHandler = MediaSession.prototype.setActionHandler;
  const pageHandlers = {};
  let inAd = false;

  // Remember YouTube's own handlers; hold off its nexttrack while an ad plays.
  MediaSession.prototype.setActionHandler = function (action, handler) {
    pageHandlers[action] = handler;
    if (inAd && (action === "nexttrack" || action === "skipad")) return;
    return setHandler.call(this, action, handler);
  };

  const player = () => document.querySelector("#movie_player");

  function skipAd() {
    const button = document.querySelector(
      ".ytp-skip-ad-button, .ytp-ad-skip-button, .ytp-ad-skip-button-modern"
    );
    if (button) {
      button.click();
      return;
    }
    // Unskippable ad: jump to its end.
    const video = player()?.querySelector("video");
    if (video && Number.isFinite(video.duration)) video.currentTime = video.duration;
  }

  function apply(action, handler) {
    try {
      setHandler.call(session, action, handler);
    } catch (_) {}
  }

  setInterval(() => {
    const showing = !!player()?.classList.contains("ad-showing");
    if (showing === inAd) return;
    inAd = showing;
    apply("nexttrack", showing ? skipAd : pageHandlers.nexttrack ?? null);
    apply("skipad", showing ? skipAd : pageHandlers.skipad ?? null);
  }, 500);
})();
