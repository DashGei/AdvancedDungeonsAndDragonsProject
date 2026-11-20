document.addEventListener('mouseover', function(e) {
  var trigger = e.target.closest('.tooltip-trigger');
  if (!trigger) return;

  var frame = trigger.querySelector('.tt-frame');
  if (!frame) return;

  var wordRect = trigger.getBoundingClientRect();
  var tipRect = frame.getBoundingClientRect();

  var left = wordRect.left + (wordRect.width / 2) - (tipRect.width / 2);
  var maxLeft = window.innerWidth - tipRect.width - 16;
  left = Math.max(16, Math.min(left, maxLeft));

  var top = wordRect.top - tipRect.height;
  if (top < 16) {
    top = wordRect.bottom;
  }

  frame.style.left = left + 'px';
  frame.style.top = top + 'px';
});

var coll = document.getElementsByClassName("collapseButton");
var i;

for (i = 0; i < coll.length; i++) {
  coll[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var content = this.nextElementSibling;
    if (content.style.display === "block") {
      content.style.display = "none";
    } else {
      content.style.display = "block";
    }
  });
} 
