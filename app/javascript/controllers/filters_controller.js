import { Controller } from "stimulus"
// const Choices = require('choices.js');
export default class extends Controller {

  clearFilters() {
    this.element.reset()
  }
}
