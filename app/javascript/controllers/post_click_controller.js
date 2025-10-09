import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = { url: String }

    connect() {
        this.element.style.cursor = "pointer"
        this.element.addEventListener("click", this.navigate.bind(this))
    }

    disconnect() {
        this.element.removeEventListener("click", this.navigate.bind(this))
    }

    navigate(event) {
        if (this.urlValue) {
            Turbo.visit(this.urlValue)
        }
    }

    stopPropagation(event) {
        event.stopPropagation()
    }
}