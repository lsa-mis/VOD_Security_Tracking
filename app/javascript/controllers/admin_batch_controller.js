import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "submit", "count"]

  connect() {
    this.update()
    this.element.addEventListener("change", () => this.update())
  }

  update() {
    const boxes = this.element.querySelectorAll("input[type='checkbox'][name='ids[]']:checked")
    const count = boxes.length
    if (this.hasCountTarget) this.countTarget.textContent = `${count} selected`
    if (this.hasSubmitTarget) this.submitTarget.disabled = count === 0
  }
}
