import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="counter"
export default class extends Controller {
  static values = { count: {type: Number, default: 0} }
  static targets = [ "output" ]
  
  addOne() {
    this.countValue++
    this.outputTarget.textContent = this.countValue
    console.log(this.countValue);
  }
}
