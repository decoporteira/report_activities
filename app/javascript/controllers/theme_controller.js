import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="theme"
export default class extends Controller {
  static targets = ["toggle"];

  connect() {
    this.applyTheme(localStorage.getItem("theme") || "light");
  }

  toggleTheme() {
    const currentTheme = document.documentElement.getAttribute("data-bs-theme");
    const newTheme = currentTheme === "light" ? "dark" : "light";
    this.applyTheme(newTheme);
  }

  applyTheme(theme) {
    document.documentElement.setAttribute("data-bs-theme", theme);
    localStorage.setItem("theme", theme);
    if (this.hasToggleTarget) {
      this.toggleTarget.textContent = theme === "dark" ? "☀️" : "🌙";
    }
  }
}
