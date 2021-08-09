import { Controller } from "stimulus"

export default class ReportController extends Controller {
  static targets = ["form", "data_type", "classification_level", "review_month", "message", "table"]

  changeTableList() {
    console.log("here")
    // data = {}
    // data = { "All": "all", "DPA exceptions": "dpa", "IT security incidents": 'isi', "Legacy OS records": "lor", "Sensitive data systems": "sds" }
    // console.log(data)
    var value = this.review_monthTarget.value
    console.log(value)

    if (value) {
      console.log("change")

      var data = { "DPA exceptions": "dpa", "Legacy OS records": "lor", "Sensitive data systems": "sds" }
    }
    else {
      var data = { "DPA exceptions": "dpa", "IT security incidents": 'isi', "Legacy OS records": "lor", "Sensitive data systems": "sds" }
    }
    console.log(data)

    let dropdown = this.tableTarget;
    dropdown.length = 0;

    let defaultOption = document.createElement('option');
    defaultOption.value = 'all';
    defaultOption.text = 'All';

    dropdown.add(defaultOption);
    dropdown.selectedIndex = 0;

    let option;

    // for (let i = 0; i < data.length; i++) {
    // data.forEach(value, text) {
    for (var val in data) {
      option = document.createElement('option');
      option.value = data[val]
      option.text = val
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
    var review_month = this.review_monthTarget.value
    var classification_level = this.classification_levelTarget.value
    var data_type = this.data_typeTarget.value
    if (review_month == "") {
      if (classification_level == "" && data_type == "") {
        this.messageTarget.innerText = "Select a review month or data classification level/data type";
        event.preventDefault()
      }
      else {
        this.messageTarget.innerText = ""
      }
    }
    else {
      this.messageTarget.innerText = ""
    }

  }

}