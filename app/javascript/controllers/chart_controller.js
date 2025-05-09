import { Controller } from "@hotwired/stimulus";

import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  static targets = ["activity", "presence"];

  connect() {
    this.renderActivityChart();
    this.renderPresenceChart();
  }

  renderActivityChart() {
    const ctx = this.activityTarget.getContext("2d");
    if (!ctx) return;

    new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: ["Feitas", "Entregues com atraso", "Não feitas"],
        datasets: [
          {
            data: JSON.parse(this.activityTarget.dataset.values),
            backgroundColor: [
              "rgb(13 110 253)",
              "rgb(255 193 7)",
              "rgb(220 53 69)",
            ],
          },
        ],
      },
      options: {
        plugins: {
          legend: { labels: { color: this.textColor() } },
        },
      },
    });
  }

  renderPresenceChart() {
    const ctx = this.presenceTarget.getContext("2d");
    if (!ctx) return;

    new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: ["Presente", "Ausente"],
        datasets: [
          {
            data: JSON.parse(this.presenceTarget.dataset.values),
            backgroundColor: ["rgb(13 110 253)", "rgb(220 53 69)"],
          },
        ],
      },
      options: {
        plugins: {
          legend: { labels: { color: this.textColor() } },
        },
      },
    });
  }

  textColor() {
    return getComputedStyle(document.body).color;
  }
}
