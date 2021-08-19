import { Controller } from "stimulus"
// const Choices = require('choices.js');
export default class extends Controller {
  static targets = ["device_id", "serial", "hostname", "device_error"]

  updateDeviceFilter() {
    var hostname = this.hostnameTarget.value
    var serial = this.serialTarget.value

    var device_id = this.device_idTarget
    if (serial != "" && hostname != "") {
      this.device_errorTarget.classList.add("device-error--display")
      this.device_errorTarget.classList.remove("device-error--hide")
    }
    else if (serial != '') {
      this.device_idTarget.value = serial
      this.device_errorTarget.classList.remove("device-error--display")
      this.device_errorTarget.classList.add("device-error--hide")
    }
    else if (hostname != '') {
      this.device_idTarget.value = hostname
      this.device_errorTarget.classList.remove("device-error--display")
      this.device_errorTarget.classList.add("device-error--hide")
    }
  }

  clearFilters() {
    this.element.reset()
    this.device_idTarget.value = ""
  }
}
