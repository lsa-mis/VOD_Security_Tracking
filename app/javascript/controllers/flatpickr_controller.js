import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static values = {
    enableTime: Boolean,
    mode: String,
    dateFormat: String,
    altFormat: String,
    altInput: Boolean
  }

  connect() {
    this.fp = flatpickr(this.element, {
      enableTime: this.enableTimeValue || false,
      mode: this.modeValue || "single",
      dateFormat: this.dateFormatValue || "Y-m-d",
      altFormat: this.altFormatValue || "F j, Y",
      altInput: this.altInputValue || true,
      allowInput: true,
      clickOpens: true,
      time_24hr: true
    })
  }

  disconnect() {
    this.fp.destroy()
  }
}
