import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleSubmit(event) {
    const form = event.target
    const input = form.querySelector("input[name*='[body]']")

    if (!input) return

    if (form.closest(".post-comment-form")) {
      input.value = ""
    } else {
      const replyContainer = form.closest(".comment-reply-form")
      if (replyContainer) {
        replyContainer.classList.add("hidden")
      }
    }
  }
}