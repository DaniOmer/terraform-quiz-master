# Pipeline CI/CD Terraform avec TFLint et Checkov

## 🚀 Vue d'ensemble

Ce pipeline CI/CD GitHub Actions intègre les meilleures pratiques pour Terraform avec :

- **TFLint** : Linting et validation des bonnes pratiques
- **Checkov** : Contrôles de sécurité et conformité
- **Terraform Plan** : Planification automatique pour tous les environnements
- **Terraform Apply** : Déploiement manuel avec approbation requise

## 📋 Fonctionnalités

### ✅ Validation automatique

- Format des fichiers Terraform
- Validation syntaxique
- Contrôles de sécurité avec Checkov
- Linting avec TFLint
- Génération de plans Terraform

### 🔒 Sécurité

- Contrôles de sécurité automatiques
- Intégration avec GitHub Security tab
- Rapports SARIF pour les vulnérabilités
- Validation des configurations DigitalOcean (Droplets, Spaces, Kubernetes)

### 🎯 Déploiement contrôlé

- **Terraform Apply manuel uniquement**
- Environnements protégés (dev, test, prod)
- Approbation requise avant déploiement
- Traçabilité complète des changements

## 🔧 Configuration

### Secrets GitHub requis

Ajoutez ces secrets dans votre repository GitHub :

```
DIGITALOCEAN_TOKEN      # Token d'API DigitalOcean
DIGITALOCEAN_SPACES_ACCESS_ID    # Clé d'accès Spaces (optionnel)
DIGITALOCEAN_SPACES_SECRET_KEY   # Clé secrète Spaces (optionnel)
```

### Variables d'environnement

Le pipeline utilise ces variables (définies dans `.github/workflows/terraform-ci-cd.yml`) :

```yaml
TF_VERSION: "1.5.7" # Version Terraform
TFLINT_VERSION: "0.48.0" # Version TFLint
CHECKOV_VERSION: "2.5.0" # Version Checkov
```

## 🚦 Déclencheurs du pipeline

### Automatique

- **Push** sur les branches `main` et `develop`
- **Pull Request** vers `main` et `develop`

### Manuel

- **Workflow Dispatch** : Déclenchement manuel avec sélection :
  - Environnement (dev/test/prod)
  - Action (plan/apply)

## 📊 Étapes du pipeline

### 1. Validation Terraform

```bash
# Vérification du format
terraform fmt -check -recursive

# Validation syntaxique
terraform validate
```

### 2. TFLint

```bash
# Analyse des modules
tflint --chdir=modules/database/ --format=compact
tflint --chdir=modules/droplet/ --format=compact
# ... pour tous les modules

# Analyse des environnements
tflint --chdir=envs/dev/ --format=compact
tflint --chdir=envs/test/ --format=compact
tflint --chdir=envs/prod/ --format=compact
```

### 3. Checkov

```bash
# Scan de sécurité
checkov -d . \
  --framework terraform \
  --output cli \
  --output sarif \
  --output-file-path . \
  --quiet \
  --compact
```

### 4. Terraform Plan

```bash
# Plan pour chaque environnement
terraform plan -out=tfplan-dev
terraform plan -out=tfplan-test
terraform plan -out=tfplan-prod
```

### 5. Terraform Apply (Manuel)

```bash
# Seulement via workflow_dispatch
terraform apply tfplan-{environment}
```

## 🎮 Utilisation

### Pull Request

1. Créez une branche feature
2. Modifiez vos fichiers Terraform
3. Poussez vos changements
4. Créez une Pull Request
5. Le pipeline s'exécute automatiquement et commente les résultats

### Déploiement

1. Allez dans **Actions** → **Terraform CI/CD Pipeline**
2. Cliquez sur **Run workflow**
3. Sélectionnez :
   - Environment (dev/test/prod)
   - Action (plan/apply)
4. Confirmez le déploiement

### Environnements GitHub

Configurez les environnements protégés dans GitHub :

1. **Settings** → **Environments**
2. Créez les environnements : `dev`, `test`, `prod`
3. Ajoutez des **Protection rules** :
   - Required reviewers (pour prod)
   - Deployment branches (main seulement)
   - Environment secrets si nécessaire

## 🔧 Configuration des outils

### TFLint (.tflint.hcl)

```hcl
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

rule "terraform_required_version" {
  enabled = true
}

rule "terraform_required_providers" {
  enabled = true
}
```

### Checkov (.checkov.yaml)

```yaml
framework:
  - terraform
  - terraform_plan

skip-check:
  - CKV_DO_3 # Droplet backup - optionnel
  - CKV_DO_4 # Droplet monitoring - optionnel

check:
  - CKV_DO_1 # Droplet monitoring enabled
  - CKV_DO_2 # Droplet private networking enabled
  - CKV_DO_5 # Spaces bucket versioning enabled
  - CKV_DO_7 # Spaces bucket encryption
  - CKV_DO_10 # Kubernetes auto-upgrade enabled
  # ... autres contrôles critiques
```

## 📝 Bonnes pratiques

### Code Terraform

- Utilisez `terraform fmt` avant de commiter
- Documentez vos variables et outputs
- Respectez les conventions de nommage (snake_case)
- Ajoutez des tags obligatoires : Name, Environment, Project

### Sécurité DigitalOcean

- Activez le monitoring et les backups pour les Droplets critiques
- Utilisez le private networking pour les communications internes
- Chiffrez les buckets Spaces avec des données sensibles
- Configurez les firewalls pour limiter l'accès
- Utilisez des clés SSH sécurisées pour l'accès aux Droplets

### Déploiement

- Testez toujours en dev avant test/prod
- Vérifiez les plans Terraform avant apply
- Utilisez des environnements séparés pour chaque étape
- Documentez les changements dans les commits

## 🐛 Résolution des problèmes

### Erreurs TFLint

```bash
# Localement
tflint --init
tflint --chdir=envs/dev/
```

### Erreurs Checkov

```bash
# Localement
checkov -d . --framework terraform
```

### Erreurs Terraform

```bash
# Localement
terraform init
terraform validate
terraform plan
```

## 📈 Monitoring

### GitHub Actions

- Consultez l'onglet **Actions** pour les logs
- Vérifiez les **Artifacts** pour les plans Terraform
- Surveillez les **Security** pour les vulnérabilités

### Rapports

- **Summary** : Résumé des contrôles de sécurité
- **SARIF** : Rapports détaillés dans Security tab
- **Comments** : Résultats dans les Pull Requests

## 🚀 Prochaines étapes

1. **Configurez le token DigitalOcean** dans GitHub
2. **Créez les environnements** protégés
3. **Testez le pipeline** avec une PR
4. **Ajustez les règles** TFLint/Checkov selon vos besoins
5. **Documentez** vos modules Terraform

## 📞 Support

Pour des questions ou des améliorations :

1. Ouvrez une issue GitHub
2. Consultez la documentation Terraform
3. Vérifiez les logs des actions GitHub

## 🌊 Ressources DigitalOcean

### Régions recommandées

- **NYC1/NYC3** : New York (Amérique du Nord)
- **AMS3** : Amsterdam (Europe)
- **SGP1** : Singapore (Asie)
- **LON1** : Londres (Europe)
- **FRA1** : Francfort (Europe)
- **SFO3** : San Francisco (Amérique du Nord)

### Tailles de Droplets courantes

- **s-1vcpu-1gb** : Basic (1 vCPU, 1GB RAM)
- **s-2vcpu-2gb** : Basic (2 vCPU, 2GB RAM)
- **c-2** : CPU-Optimized (2 vCPU, 4GB RAM)
- **m-2vcpu-16gb** : Memory-Optimized (2 vCPU, 16GB RAM)

---

**⚠️ Important** : Ce pipeline respecte la bonne pratique de ne **jamais** faire d'apply automatique. Tous les déploiements nécessitent une intervention manuelle et une approbation.
