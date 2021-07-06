import { Controller } from "stimulus"

export default class SensitivedsController extends Controller {
  static targets = ["storage_location", "system_device", "form", "serial", "hostname", "serial_error", "hostname_error"]

  initialize() {
    this.checkIfDeviceIsRequired()
  }

  checkIfDeviceIsRequired() {
    let id = this.storage_locationTarget.value;
    if (id) {
      fetch(`/storage_locations/is_device_required/${id}`)
        .then((response) => response.json())
        .then((data) => this.display_device(data)
        );
    }
  }

  display_device(data) {
    this.device_is_required = data
    var val = this.system_deviceTarget.classList.value

    if (data) {
      if (val.includes("device--hide")) {
        val = val.replace("device--hide", "device--display")
        this.system_deviceTarget.classList.value = val
      }
    }
    else {
      if (val.includes("device--display")) {
        val = val.replace("device--display", "device--hide")
        this.system_deviceTarget.classList.value = val
        if (this.serialTarget) {
          this.serialTarget.value = ""
        }
        if (this.hostnameTarget) {
          this.hostnameTarget.value = ""
        }
      }
    }
  }

  submitForm(event) {
    if (this.device_is_required) {
      var serial = this.serialTarget.value
      var hostname = this.hostnameTarget.value
      if (serial == "" && hostname == "") {
        this.serial_errorTarget.classList.add("device-error--display")
        this.serial_errorTarget.classList.remove("device-error--hide")
        this.hostname_errorTarget.classList.add("device-error--display")
        this.hostname_errorTarget.classList.remove("device-error--hide")
        event.preventDefault()
      }
      else {
        this.serial_errorTarget.classList.add("device-error--hide")
        this.serial_errorTarget.classList.remove("device-error--display")
        this.hostname_errorTarget.classList.add("device-error--hide")
        this.hostname_errorTarget.classList.remove("device-error--display")
      }
    }
  }

}