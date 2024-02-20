// Add click to copy function to code blocks
function copy(event) {
  const node = event.currentTarget;
  const code = node.parentNode.querySelector("code");
  navigator.clipboard.writeText(code.textContent);
  node.innerText = "Copied";
  setTimeout(() => {
    node.innerText = "Copy";
  }, 750);
}

function addCopyButton(codeBlock) {
  const btn = document.createElement("button");
  btn.classList.add("copy");
  btn.innerText = "Copy";

  btn.addEventListener("click", copy);
  codeBlock.appendChild(btn);
}

if (window.getSelection && navigator.clipboard) {
  // Markdown
  document
    .querySelectorAll("div.highlight")
    .forEach((codeBlock) => addCopyButton(codeBlock));
  // AsciiDoc
  document
    .querySelectorAll("div.listingblock > div.content")
    .forEach((codeBlock) => addCopyButton(codeBlock));
}

// Make mobile 'Content' toggle on 'Enter' and 'Space'
const menuToggleLabel = document.querySelector("label[tabindex]");
menuToggleLabel.addEventListener("keydown", (e) => {
  if (e.key == " " || e.key == "Enter") {
    e.preventDefault();
    e.currentTarget.click();
  }
});

// Make navigation links unfocussable if the menu is closed
const menuToggle = document.getElementById("menu");
const navLinks = document.querySelectorAll("#nav a");

menuToggle.addEventListener("change", (e) => {
  if (e.currentTarget.checked) {
    navLinks.forEach((link) => link.removeAttribute("tabindex"));
  } else {
    navLinks.forEach((link) => link.setAttribute("tabindex", "-1"));
  }
});
