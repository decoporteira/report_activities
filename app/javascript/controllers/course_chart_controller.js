import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  static targets = ["course"];

  connect() {
    if (this.hasCourseTarget) {
      this.renderChart();
    }
  }

  renderChart() {
    const ctx = this.courseTarget.getContext("2d");

    new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: ["Kids", "Teens", "Adults", "Privates"],
        datasets: [
          {
            label: "Total por Categoria",
            backgroundColor: ["#4e73df", "#1cc88a", "#36b9cc", "#f6c23e"],
            data: JSON.parse(this.courseTarget.dataset.values),
          },
        ],
      },
      options: {
        plugins: {
          tooltip: {
            callbacks: {
              label: function (context) {
                return "Alunos: " + context.raw;
              },
            },
          },
        },
      },
    });
  }
}
