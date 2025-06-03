import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "field"];

  connect() {
    this.toggleFields();
  }

  toggleFields() {
    const selectedPlanId = this.selectTarget.value;

    this.fieldTargets.forEach((element) => {
      const showId = element.dataset.showIfPlanId;
      const hideId = element.dataset.hideIfPlanId;

      if (showId !== undefined) {
        element.style.display = selectedPlanId === showId ? "block" : "none";
      } else if (hideId !== undefined) {
        element.style.display = selectedPlanId !== hideId ? "block" : "none";
      }
    });
  }
}
