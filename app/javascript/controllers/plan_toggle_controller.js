import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "field"];

  connect() {
    this.toggleFields();
    this.selectTarget.addEventListener("change", () => this.toggleFields());
  }

  toggleFields() {
    const selectedPlanId = this.selectTarget.value;

    this.fieldTargets.forEach((element) => {
      const showIds = element.dataset.showIfPlanId?.split(",") || [];
      const hideIds = element.dataset.hideIfPlanId?.split(",") || [];

      if (showIds.length > 0) {
        element.style.display = showIds.includes(selectedPlanId)
          ? "block"
          : "none";
      } else if (hideIds.length > 0) {
        element.style.display = !hideIds.includes(selectedPlanId)
          ? "block"
          : "none";
      }
    });
  }
}
