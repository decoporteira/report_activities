import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { valor: String };

  mostrarMensagem() {
    alert("Pagando no valor de: " + this.valorValue);
  }
}
