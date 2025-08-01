import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    fee: String,
    billingType: String,
    monthly: String,
  };

  mostrarPromptEEnviar(event) {
    if (this.billingTypeValue === "monthly") {
      return;
    }
    event.preventDefault();
    let msg;
    if (this.billingTypeValue === "both") {
      msg =
        "Valor de aulas particulares: " +
        this.feeValue +
        " Mensalidade: " +
        this.monthlyValue;
    } else {
      msg = "Valor de aulas particulares: " + this.feeValue;
    }
    const insertedValue = prompt(msg);

    if (insertedValue === null) {
      return;
    }
    const form = this.element.closest("form");
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = "valor_pagamento";
    input.value = insertedValue;
    form.appendChild(input);
    form.submit();
  }
}
