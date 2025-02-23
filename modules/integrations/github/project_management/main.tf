locals {
  repository_name = "kanban"
  github_owner    = "dkarter"
}


terraform {
  required_version = "~> 1.10"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.45.0"
    }
  }
}

provider "github" {
  owner = local.github_owner
}

resource "github_repository" "kanban" {
  name                   = local.repository_name
  description            = "Taking the BEAM to production pragmatically."
  visibility             = "private"
  has_issues             = true
  auto_init              = true
  gitignore_template     = "Terraform"
  delete_branch_on_merge = true
}


variable "milestones" {
  type = map(object({
    title       = string
    due_date    = optional(string)
    description = string
  }))
  description = "Milestones, consider them the biggest deliverable unit."
}

resource "github_repository_milestone" "epics" {
  depends_on  = [github_repository.kanban]
  for_each    = var.milestones
  repository  = local.repository_name
  owner       = local.github_owner
  title       = each.value.title
  description = replace(each.value.description, "\n", " ")
  due_date    = each.value.due_date
}

variable "labels" {
  type = map(object({
    name  = string
    color = string
  }))
  description = "The labels to tag the issues"
}
resource "github_issue_label" "issue_labels" {
  depends_on = [github_repository.kanban]
  for_each   = var.labels
  repository = local.repository_name
  name       = each.value.name
  color      = each.value.color
}

variable "issues" {
  type = list(object({
    title     = string
    body      = optional(string)
    labels    = list(string)
    milestone = string
  }))
  description = "Github Issues to work on"
}

resource "github_issue" "project_issues" {
  depends_on = [github_repository.kanban]
  count      = length(var.issues)
  repository = local.repository_name
  title      = var.issues[count.index].title
  body       = var.issues[count.index].body
  milestone_number = github_repository_milestone.epics[
    var.issues[count.index].milestone
  ].number
  labels = [
    for l in var.issues[count.index].labels :
    github_issue_label.issue_labels[l].name
  ]
}
