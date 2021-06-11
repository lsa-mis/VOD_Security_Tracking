import { Controller } from "stimulus"

export default class SensitivedsController extends Controller {
  static targets = ["storage_location", "system_device", "form", "serial", "hostname", "device_error"]

  checkIfDeviceIsRequired() {
    let id = this.storage_locationTarget.value;
    fetch(`/storage_locations/is_device_required/${id}`)
      .then((response) => response.json())
      .then((data) => this.display_device(data)
      );
  }

  display_device(data) {
    if (data) {
      this.system_deviceTarget.classList.add("device--display")
      this.system_deviceTarget.classList.remove("device--hide")
      if (this.system_deviceTarget.classList[0] == "device--display") {
      }
    }
    else {
      this.system_deviceTarget.classList.add("device--hide")
      this.system_deviceTarget.classList.remove("device--display")
    }
  }

  submitForm(event) {
    if (this.system_deviceTarget.classList[0] == "device--display") {
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

}