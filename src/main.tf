resource "github_team" "employee" {
  name        = "test-team"
  description = "A test team"
  privacy     = "closed"
}

resource "github_team_membership" "employee_team_membership" {
  for_each = var.employee_account_name

  team_id  = github_team.employee.id
  username = each.value
  role     = var.employee_role[each.key]
}
