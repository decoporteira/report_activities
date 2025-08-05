import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    fee: String,
    billingType: String,
    monthly: String,
  };

  async mostrarPromptEEnviar(event) {
    if (this.billingTypeValue === "monthly") {
      return;
    }
    event.preventDefault();
    const button = event.currentTarget;
    const studentId = button.dataset.paymentStudentId;
    const date = button.dataset.paymentDate;

    const response = await fetch(
      `/students/${studentId}/private_classes_value?date=${date}`
    );
    const data = await response.json();
    let msg;
    if (this.billingTypeValue === "both") {
      msg =
        "Valor de aulas particulares: " +
        data.value +
        " Mensalidade: " +
        this.monthlyValue;
    } else {
      msg = "Valor de aulas particulares: " + data.value;
    }
    const insertedValue = prompt(msg);

    if (insertedValue === null) {
      return;
    }
    const sanitizedValue = insertedValue.replace(",", ".");

    const form = this.element.closest("form");
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = "valor_pagamento";
    input.value = sanitizedValue;
    form.appendChild(input);
    form.submit();
  }
}
