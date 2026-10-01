# Project QA — GitHub Readiness

Contrôles réalisés avant publication du dépôt.

## Résultat

**Statut : prêt pour GitHub.**

## Contrôles effectués

- Structure du dépôt vérifiée.
- `README.md` mis à jour avec les 4 captures Power BI.
- Captures renommées avec des noms explicites.
- Fichiers locaux/cache Power BI `.pbi/` supprimés du dépôt.
- `.gitignore` renforcé pour exclure `.pbi/`, caches Python, environnements virtuels et fichiers temporaires.
- Chemins `/mnt/data/...` supprimés des notebooks et remplacés par des chemins relatifs/portables.
- Cohérence des KPI vérifiée sur le CSV et la base SQLite.
- Base SQLite : 10 000 transactions, 129 agents, 2 500 clients référencés dans la dimension.
- Clients réellement actifs dans les transactions : 2 458.
- Aucun secret, mot de passe, token ou adresse e-mail personnelle détecté dans les fichiers texte du dépôt.
- Aucun fichier individuel ne dépasse la limite GitHub de 100 Mo.
- Schéma SQL complété avec la vue analytique utilisée par les notebooks.
- Notebook source exécuté de bout en bout avec succès après nettoyage.

## KPI de référence

| KPI | Valeur |
|---|---:|
| Transactions | 10 000 |
| Taux de succès | 97,28 % |
| Valeur réussie | 226 335 400 FCFA |
| Frais | 1 299 080 FCFA |
| Commissions agents | 281 934 FCFA |
| Revenu net | 1 017 146 FCFA |
| Clients actifs | 2 458 |
| Agents actifs | 129 |

## Avant publication

Créer un dépôt GitHub nommé par exemple :

`Mobile-Money-Analytics-Cameroon`

Puis déposer **le contenu du dossier du projet**, et non le dossier ZIP lui-même.
