import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "field"];

  connect() {
    this.toggleFields(); // chama ao iniciar para ajustar a visibilidade
  }

  toggleFields() {
    const selectedPlanId = this.selectTarget.value;

    this.fieldTargets.forEach((element) => {
      if (element.dataset.planId === selectedPlanId) {
        element.style.display = "block";
      } else {
        element.style.display = "none";
      }
    });
  }
}
