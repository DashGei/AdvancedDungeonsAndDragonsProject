document.querySelectorAll("[data-tt]").forEach(trigger => {

    const ttId = trigger.dataset.tt;
    const tt = document.getElementById(ttId);

    if (!tt) return;

    trigger.addEventListener("mouseover", () => {
        tt.classList.add("vis");
    });

    trigger.addEventListener("mouseleave", () => {
        tt.classList.remove("vis");
    });

});