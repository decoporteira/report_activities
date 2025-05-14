import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
  static targets = ["monthly"];

  connect() {
    if (document.getElementById("monthly")) this.renderMonthlyChart();
  }

  renderMonthlyChart() {
    const ctx = this.monthlyTarget?.getContext("2d"); // <- CORRIGIDO AQUI
    if (!ctx) return;
    const monthlyData = JSON.parse(this.monthlyTarget.dataset.values);

    // Extraindo os labels e os valores para o gráfico
    const labels = Object.keys(monthlyData);
    const data = Object.values(monthlyData);
    new Chart(ctx, {
      type: "bar",
      data: {
        labels: labels,
        datasets: [
          {
            label: "Mensal:",
            backgroundColor: ["#4e73df", "#1cc88a", "#36b9cc", "#f6c23e"],
            hoverBackgroundColor: ["#4e73df", "#1cc88a", "#36b9cc", "#f6c23e"],
            data: data,
          },
        ],
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: function (context) {
                return (
                  "R$ " +
                  context.raw.toLocaleString("pt-BR", {
                    minimumFractionDigits: 2,
                  })
                );
              },
            },
          },
        },
      },
    });
  }
}
