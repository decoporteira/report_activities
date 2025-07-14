import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    valor: String,
  };

  mostrarPromptEEnviar(event) {
    event.preventDefault();
    const valorDigitado = prompt(
      "Digite o valor do pagamento: " + this.valorValue
    );

    if (valorDigitado === null || valorDigitado.trim() === "") {
      return;
    }
    const form = this.element.closest("form");
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = "valor_pagamento";
    input.value = valorDigitado;
    form.appendChild(input);
    form.submit();
  }
}
