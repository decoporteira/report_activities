import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "row"];

  connect() {
    this.inputTarget.addEventListener("keyup", () => this.filter());
  }

  removeAccents(str) {
    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
  }

  filter() {
    const value = this.removeAccents(
      this.inputTarget.value.toLowerCase().trim()
    );
    const words = value.split(/\s+/);

    this.rowTargets.forEach((row) => {
      const text = this.removeAccents(row.textContent.toLowerCase());
      const match = words.every((word) => text.includes(word));
      row.style.display = match ? "" : "none";
    });
  }
}
