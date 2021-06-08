import { Controller } from "stimulus"

export default class SensitivedsController extends Controller {
  static targets = ["sensitive_data_system_type", "system_device", "form", "serial", "hostname"]

  connect() {
    this.display_device()
  }

  display_device() {
    var type = this.sensitive_data_system_typeTarget.value
    if (type == 1) {
      this.system_deviceTarget.classList.add("device--display")
      this.system_deviceTarget.classList.remove("device--hide")
    }
    else {
      this.system_deviceTarget.classList.add("device--hide")
      this.system_deviceTarget.classList.remove("device--display")
    }
  }

  submitForm(event) {
    var type = this.sensitive_data_system_typeTarget.value
    if (type == 1) {
      let isValid = this.validateForm(this.formTarget);
      if (!isValid) {
        this.system_deviceTarget.append("Add serial number or hostname");
        event.preventDefault();
      }
    }
  }

  validateForm() {
    let isValid = true;
    var system_type = this.sensitive_data_system_typeTarget.value
    var serial = this.serialTarget.value
    var hostname = this.hostnameTarget.value
    if (system_type == 1) {
      if (serial == "" && hostname == "") {
        isValid = false;
      }
      else {
        isValid = true;
      }
      return isValid;
    }
  }
}