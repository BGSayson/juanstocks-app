import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["select", "buySell", "buyStock", "buy", "sell", "investment", "withdrawDeposit", "withdrawDepositMode", "all", "submit"]
  
  connect() {
    this.hide()
  }

  hide() {
    const dropdownValue = this.selectTarget.value;
    const buySell = this.buySellTarget.classList;
    const buyMode = this.buyStockTarget.classList;
    const withAndDep = this.withdrawDepositTarget.classList;
    const withAndDep2 = this.withdrawDepositModeTarget.classList;
    const invSelect = this.investmentTarget.classList;
    const submitButton = this.submitTarget.classList;

    if (dropdownValue === "buy") {
        if (!withAndDep.contains("hidden")) {
          withAndDep.add("hidden")
        }
        if (!withAndDep2.contains("hidden")) {
          withAndDep2.add("hidden")
        }
        if (!invSelect.contains("hidden")) {
          invSelect.add("hidden")
        }
      submitButton.remove("hidden");
      buyMode.remove("hidden");
      buySell.remove("hidden");
      
    } else if (dropdownValue === "sell") {
        if (!withAndDep.contains("hidden")) {
          withAndDep.add("hidden")
        }
        if (!withAndDep2.contains("hidden")) {
          withAndDep2.add("hidden")
        }
        if (!buyMode.contains("hidden")) {
          buyMode.add("hidden");
        }
      invSelect.remove("hidden");
      submitButton.remove("hidden");
      buySell.remove("hidden");

    } else if (dropdownValue === "withdraw" || dropdownValue === "deposit") {
        if (!buySell.contains("hidden")) {
          buySell.add("hidden")
          buyMode.add("hidden");
        }
        if (!invSelect.contains("hidden")) {
          invSelect.add("hidden");
        }
      withAndDep.remove("hidden");
      withAndDep2.remove("hidden");
      submitButton.remove("hidden")
    } else {
      this.allTarget.style.classList.remove("hidden")
    }
  }
}
