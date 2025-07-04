# Guide des Workflows Terraform

Ce projet utilise deux workflows GitHub Actions séparés pour une gestion sécurisée et contrôlée des déploiements Terraform.

## 📋 Vue d'ensemble

### 1. Workflow Principal (`terraform-ci-cd.yml`)

- **Déclenchement** : Automatique sur push/PR vers `main` ou `dev`
- **Responsabilités** : Validation, linting, scan de sécurité, génération des plans
- **Artifacts** : Sauvegarde les plans Terraform avec le SHA Git

### 2. Workflow d'Application (`terraform-apply.yml`)

- **Déclenchement** : Manuel uniquement via `workflow_dispatch`
- **Responsabilités** : Application des plans pré-générés
- **Sécurité** : Validation des plans, environnements GitHub, approbations

## 🚀 Utilisation

### Étape 1: Générer les Plans

1. Créez une PR ou poussez du code vers `main`/`dev`
2. Le workflow `terraform-ci-cd` s'exécute automatiquement
3. Les plans sont générés pour chaque environnement (dev/prod)
4. Les plans sont sauvegardés comme artifacts avec le SHA Git

### Étape 2: Appliquer les Plans

1. Allez dans l'onglet **Actions** de votre repository
2. Sélectionnez le workflow **"Terraform Apply"**
3. Cliquez sur **"Run workflow"**
4. Remplissez les paramètres :
   - **Environment** : `dev`, `test`, ou `prod`
   - **Git SHA** : Le SHA du commit dont vous voulez appliquer le plan
   - **Action** : `apply`, `show-plan`, ou `destroy`

### Récupération du SHA Git

Le SHA Git est disponible dans :

- Les commentaires de PR (après le plan)
- L'output du workflow `terraform-ci-cd`
- La ligne de commande : `git rev-parse HEAD`

## 🔒 Sécurité

### Environnements GitHub

Chaque environnement peut avoir ses propres règles :

- **Approbations manuelles** requises
- **Réviseurs** spécifiques
- **Délais d'attente**
- **Secrets** spécifiques à l'environnement

### Validation des Plans

- Le workflow apply vérifie que le plan existe
- Utilise le SHA Git exact pour garantir la cohérence
- Affiche un résumé avant l'application

## 📁 Structure des Artifacts

Les artifacts sont nommés selon le pattern :

```
tfplan-{environment}-{git-sha}
```

Exemple :

```
tfplan-dev-abc123def456
tfplan-prod-abc123def456
```

## 🛠️ Actions Disponibles

### Apply

- Applique le plan pré-généré
- Crée des ressources dans l'environnement cible
- Commente les résultats sur le commit

### Show Plan

- Affiche le contenu du plan sans l'appliquer
- Utile pour révision avant déploiement
- Pas d'impact sur l'infrastructure

### Destroy

- Détruit toutes les ressources de l'environnement
- **⚠️ ATTENTION** : Action irréversible
- Utiliser avec précaution

## 📊 Monitoring et Logs

### Résultats des Jobs

- **GitHub Step Summary** : Résumé visuel dans l'interface
- **Commentaires** : Résultats automatiquement commentés
- **Logs** : Détails complets dans les logs du workflow

### Artifacts

- **Retention** : 30 jours par défaut
- **Téléchargement** : Possible via l'interface GitHub
- **Contenu** : Plans, outputs, et résumés

## 🔄 Exemple de Workflow Complet

1. **Développement**

   ```bash
   git checkout -b feature/new-resource
   # Modifier le code Terraform
   git commit -m "Add new resource"
   git push origin feature/new-resource
   ```

2. **Révision**

   - Créer une PR
   - Le workflow `terraform-ci-cd` s'exécute
   - Réviser les plans dans les commentaires de PR

3. **Merge**

   ```bash
   git checkout main
   git merge feature/new-resource
   git push origin main
   ```

4. **Déploiement**
   - Aller dans Actions > Terraform Apply
   - Entrer l'environnement et le SHA Git
   - Approuver le déploiement si nécessaire

## 🚨 Bonnes Pratiques

### Avant le Déploiement

- ✅ Vérifier les résultats du scan de sécurité
- ✅ Réviser le plan dans les commentaires
- ✅ Confirmer le SHA Git correct
- ✅ Tester en dev avant prod

### Après le Déploiement

- ✅ Vérifier l'état des ressources
- ✅ Contrôler les logs applicatifs
- ✅ Valider le fonctionnement
- ✅ Documenter les changements

## 📞 Dépannage

### Plan Artifact Non Trouvé

- Vérifier que le workflow `terraform-ci-cd` a réussi
- Confirmer que le SHA Git est correct
- Vérifier que l'artifact n'a pas expiré (30 jours)

### Échec de l'Application

- Consulter les logs détaillés du workflow
- Vérifier l'état Terraform
- Considérer un nouveau plan si nécessaire

### Problèmes de Permissions

- Vérifier les secrets d'environnement
- Confirmer les permissions GitHub
- Vérifier les règles d'environnement
