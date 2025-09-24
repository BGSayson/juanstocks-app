import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="alert"
export default class extends Controller {
  // connect() {
  // }

  show(){
    alert("DING DING DING DING")
  }

  huh() {
    this.element.style.color = "red"
    console.log("what");
  }
}
