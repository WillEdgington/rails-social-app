import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["replyForm", "replies"]

    toggleReply(event) {
        event.preventDefault()
        this.replyFormTarget.classList.toggle("hidden")

        const link = event.currentTarget
        if (this.replyFormTarget.classList.contains("hidden")) {
            link.textContent = `Reply`
        } else {
            link.textContent = "X"
        }
    }

    toggleReplies(event) {
        event.preventDefault()
        this.repliesTarget.classList.toggle("hidden")

        const link = event.currentTarget
        if (this.repliesTarget.classList.contains("hidden")) {
            link.textContent = `See replies (${this.repliesTarget.childElementCount})`
        } else {
            link.textContent = "Hide replies"
        }
    }
}