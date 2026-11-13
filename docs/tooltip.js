document.addEventListener('mouseover', function(e) {
  var trigger = e.target.closest('.tooltip-trigger');
  if (!trigger) return;

  var frame = trigger.querySelector('.tt-frame');
  if (!frame) return;

  var wordRect = trigger.getBoundingClientRect();
  var tipRect = frame.getBoundingClientRect();

  // Center over the word, then clamp 16px inside left & right screen edges
  var left = wordRect.left + (wordRect.width / 2) - (tipRect.width / 2);
  var maxLeft = window.innerWidth - tipRect.width - 16;
  left = Math.max(16, Math.min(left, maxLeft));

  // Position above the word, or flip below if near the top of the screen
  var top = wordRect.top - tipRect.height - 1;
  if (top < 16) {
    top = wordRect.bottom + 1;
  }

  frame.style.left = left + 'px';
  frame.style.top = top + 'px';
});
