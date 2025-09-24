import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="greeter"
export default class extends Controller {
  static targets = [ "name", "output" ]
  
  greet() {
    this.outputTarget.innerHTML = `Hello ${this.nameTarget.value}`
    this.outputTarget.style.color = "blue"
  }
}
