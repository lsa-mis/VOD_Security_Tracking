import { Controller } from "stimulus"

export default class LegacyosController extends Controller {
  static targets = ["form", "system_device", "serial", "hostname", "device_error"]

  submitForm(event) {
    var serial = this.serialTarget.value
    var hostname = this.hostnameTarget.value
    if (serial == "" && hostname == "") {
      this.device_errorTarget.classList.add("device-error--display")
      this.device_errorTarget.classList.remove("device-error--hide")
      event.preventDefault()
    }
    else {
      this.device_errorTarget.classList.add("device-error--hide")
      this.device_errorTarget.classList.remove("device-error--display")
    }
  }

}