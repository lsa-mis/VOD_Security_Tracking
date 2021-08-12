import { Controller } from "stimulus"
export default class ReportController extends Controller {
  static targets = ["form", "data_type", "classification_level", "review_month", "message",
    "table", "end_date", "start_date", "end_date", "listing"]

  checkReviewMonth() {
    var table = this.tableTarget.value

    if (table == "isi") {
      this.review_monthTarget.disabled = true
    }
    else {
      this.review_monthTarget.disabled = false
    }
  }

  checkTable() {
    var review_month = this.review_monthTarget.value
    var selected = this.tableTarget.value
    var dropdown = this.tableTarget;
    dropdown.length = 0;
    var defaultOption = document.createElement('option');
    if (review_month) {
      var data = { "dpa": "DPA exceptions", "lor": "Legacy OS records", "sds": "Sensitive data systems" }
    }
    else {
      var data = { "dpa": "DPA exceptions", "isi": "IT security incidents", "lor": "Legacy OS records", "sds": "Sensitive data systems" }
    }
    defaultOption.value = 'all';
    defaultOption.text = "All";
    dropdown.add(defaultOption);
    dropdown.selectedIndex = 0;
    let option;

    for (var [key, value] of Object.entries(data)) {
      option = document.createElement('option');
      option.value = key
      option.text = value
      option.selected = key === selected
      dropdown.add(option);
    }

  }

  changeClassification() {
    var id = this.classification_levelTarget.value
    if (id) {
      fetch(`/data_classification_levels/get_data_types/${id}`)
        .then((response) => response.json())
        .then((data) => this.update_data_type(data)
        );
    }
    else {
      id = 0
      fetch(`/data_classification_levels/get_data_types/${id}`)
        .then((response) => response.json())
        .then((data) => this.update_data_type(data)
        );
    }
  }

  update_data_type(data) {
    let dropdown = this.data_typeTarget;
    dropdown.length = 0;

    let defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.text = 'Select data type...';

    dropdown.add(defaultOption);
    dropdown.selectedIndex = 0;

    let option;
    for (let i = 0; i < data.length; i++) {
      option = document.createElement('option');
      option.value = data[i].id;
      option.text = data[i].name;
      dropdown.add(option);
    }
  }

  submitForm(event) {

    var table = this.tableTarget.value
    var review_month = this.review_monthTarget.value
    var classification_level = this.classification_levelTarget.value
    var data_type = this.data_typeTarget.value
    let start = this.start_dateTarget.value;
    let end = this.end_dateTarget.value;
    var d_start = Date.parse(start)
    var d_end = Date.parse(end)
    if (review_month == "" && classification_level == "" && data_type == "" && start == "" && end == "") {
      this.messageTarget.classList.add("device-error--display")
      this.messageTarget.classList.remove("device-error--hide")
      this.messageTarget.innerText = "Select a review month or data classification level or data type or date range";
      event.preventDefault()
    }
    else if (d_end < d_start) {
      this.messageTarget.classList.add("device-error--display")
      this.messageTarget.classList.remove("device-error--hide")
      this.messageTarget.innerText = "[From] date should occur before [To] date";
      event.preventDefault()
    }
    // else if (review_month != "" && table == "isi") {
    //   this.messageTarget.classList.add("device-error--display")
    //   this.messageTarget.classList.remove("device-error--hide")
    //   this.messageTarget.innerText = "IT security table is not included into the Review month - select a different table or All";
    //   event.preventDefault()
    // }
    else {
      console.log(this.messageTarget.classList)
      this.messageTarget.classList.add("device-error--hide")
      this.messageTarget.classList.remove("device-error--display")
      this.messageTarget.innerText = " "
    }
  }

  clearFilters() {
    this.formTarget.reset()
    this.changeClassification()
    this.review_monthTarget.disabled = false
    this.messageTarget.classList.add("device-error--hide")
    this.messageTarget.classList.remove("device-error--display")
    this.messageTarget.innerText = " "
    this.listingTarget.innerText = ""
  }

}