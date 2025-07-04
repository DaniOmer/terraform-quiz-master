plugin "terraform" {
  enabled = true
  # Retirer le preset pour contrôler explicitement les règles
  # preset  = "recommended"
}

config {
  # Désactiver les règles par défaut pour avoir un contrôle total
  disabled_by_default = true
  
  # Forcer la validation des modules
  force = false
  
  # Activer les règles personnalisées
  call_module_type = "all"
}

# Activer seulement les règles utiles pour un projet Terragrunt
rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

# CES RÈGLES SONT DÉSACTIVÉES car gérées par Terragrunt
rule "terraform_required_version" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

# Désactivé car Terragrunt gère les providers
rule "terraform_unused_required_providers" {
  enabled = false
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

# Règles spécifiques aux modules
rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_module_version" {
  enabled = true
} 