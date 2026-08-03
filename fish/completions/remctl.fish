# Fish completion for remctl
complete -c remctl -n "__fish_use_subcommand" -a lists -d "List all iCloud reminder lists"
complete -c remctl -n "__fish_use_subcommand" -a groups -d "List Reminders list groups"
complete -c remctl -n "__fish_use_subcommand" -a group-info -d "Show details for a Reminders list group"
complete -c remctl -n "__fish_use_subcommand" -a group-create -d "Create a Reminders list group"
complete -c remctl -n "__fish_use_subcommand" -a group-edit -d "Rename a group or add/remove child lists"
complete -c remctl -n "__fish_use_subcommand" -a group-delete -d "Delete a Reminders list group"
complete -c remctl -n "__fish_use_subcommand" -a smart-lists -d "Inspect Reminders smart lists"
complete -c remctl -n "__fish_use_subcommand" -a templates -d "Inspect saved Reminders templates"
complete -c remctl -n "__fish_use_subcommand" -a template-info -d "Show a saved Reminders template"
complete -c remctl -n "__fish_use_subcommand" -a show -d "Show reminders in a list"
complete -c remctl -n "__fish_use_subcommand" -a add -d "Add a reminder"
complete -c remctl -n "__fish_use_subcommand" -a done -d "Complete a reminder"
complete -c remctl -n "__fish_use_subcommand" -a undone -d "Uncomplete a reminder"
complete -c remctl -n "__fish_use_subcommand" -a edit -d "Edit a reminder"
complete -c remctl -n "__fish_use_subcommand" -a delete -d "Delete a reminder"
complete -c remctl -n "__fish_use_subcommand" -a search -d "Search reminders"
complete -c remctl -n "__fish_use_subcommand" -a today -d "Due today + overdue"
complete -c remctl -n "__fish_use_subcommand" -a upcoming -d "Next N days"
complete -c remctl -n "__fish_use_subcommand" -a overdue -d "All overdue reminders"
complete -c remctl -n "__fish_use_subcommand" -a flagged -d "Flagged reminders"
complete -c remctl -n "__fish_use_subcommand" -a urgent -d "Urgent reminders"
complete -c remctl -n "__fish_use_subcommand" -a flag -d "Flag a reminder"
complete -c remctl -n "__fish_use_subcommand" -a unflag -d "Unflag a reminder"
complete -c remctl -n "__fish_use_subcommand" -a tags -d "List all tags"
complete -c remctl -n "__fish_use_subcommand" -a subtasks -d "Show subtasks"
complete -c remctl -n "__fish_use_subcommand" -a info -d "Full detail view"
complete -c remctl -n "__fish_use_subcommand" -a sections -d "Show sections"
complete -c remctl -n "__fish_use_subcommand" -a section-create -d "Create a section in a list"
complete -c remctl -n "__fish_use_subcommand" -a section-rename -d "Rename a section in a list"
complete -c remctl -n "__fish_use_subcommand" -a section-delete -d "Delete a section in a list"
complete -c remctl -n "__fish_use_subcommand" -a sharees -d "Show people available for assignment in a shared list"
complete -c remctl -n "__fish_use_subcommand" -a stats -d "Statistics"
complete -c remctl -n "__fish_use_subcommand" -a link -d "Get deep links"
complete -c remctl -n "__fish_use_subcommand" -a open -d "Open in Reminders.app"
complete -c remctl -n "__fish_use_subcommand" -a export -d "Export reminders"
complete -c remctl -n "__fish_use_subcommand" -a import -d "Import reminders"
complete -c remctl -n "__fish_use_subcommand" -a list-symbols -d "List official Reminders list symbols"
complete -c remctl -n "__fish_use_subcommand" -a list-create -d "Create a new list"
complete -c remctl -n "__fish_use_subcommand" -a smart-list-create -d "Create a private custom smart list"
complete -c remctl -n "__fish_use_subcommand" -a smart-list-edit -d "Edit a private custom smart list"
complete -c remctl -n "__fish_use_subcommand" -a smart-list-delete -d "Delete a private custom smart list"
complete -c remctl -n "__fish_use_subcommand" -a template-create -d "Create a private Reminders template from an entire list"
complete -c remctl -n "__fish_use_subcommand" -a template-apply -d "Create a list from a saved Reminders template"
complete -c remctl -n "__fish_use_subcommand" -a template-delete -d "Delete a saved Reminders template"
complete -c remctl -n "__fish_use_subcommand" -a list-edit -d "Edit private list appearance"
complete -c remctl -n "__fish_use_subcommand" -a list-pin -d "Pin a list or smart list in Reminders"
complete -c remctl -n "__fish_use_subcommand" -a list-unpin -d "Unpin a list or smart list in Reminders"
complete -c remctl -n "__fish_use_subcommand" -a list-rename -d "Rename a list"
complete -c remctl -n "__fish_use_subcommand" -a list-delete -d "Delete a list"
complete -c remctl -n "__fish_use_subcommand" -a onboard -d "Prompt for macOS permissions and verify readiness"
complete -c remctl -n "__fish_use_subcommand" -a doctor -d "Diagnose setup and runtime issues"
complete -c remctl -n "__fish_use_subcommand" -a setup -d "Install shell completions"
complete -c remctl -n "__fish_use_subcommand" -a permissions -d "Open guided macOS permission helper"
complete -c remctl -n "__fish_use_subcommand" -a completion -d "Generate shell completions"
complete -c remctl -l images -d "Render image attachments inline"
complete -c remctl -l image-mode -d "Image rendering protocol" -x -a "kitty iterm2 halfblock none"
complete -c remctl -l image-width -d "Image render width in cells" -x
complete -c remctl -n "__fish_seen_subcommand_from doctor" -l for-agent -d "Print agent-focused context and TCC guidance"
complete -c remctl -n "__fish_seen_subcommand_from show" -l list-id -d "Show list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from show" -l completed -d "Include completed reminders"
complete -c remctl -n "__fish_seen_subcommand_from show" -l via-eventkit -d "Limited read-only EventKit fallback; no numeric ids or private metadata"
complete -c remctl -n "__fish_seen_subcommand_from show" -s v -l verbose -d "Verbose output"
complete -c remctl -n "__fish_seen_subcommand_from search" -l completed -d "Include completed reminders"
complete -c remctl -n "__fish_seen_subcommand_from search today upcoming" -l via-eventkit -d "Limited read-only EventKit fallback; no numeric ids or private metadata"
complete -c remctl -n "__fish_seen_subcommand_from search today upcoming" -s v -l verbose -d "Verbose output"
complete -c remctl -n "__fish_seen_subcommand_from today" -l no-overdue -d "Exclude overdue reminders"
complete -c remctl -n "__fish_seen_subcommand_from done" -l date -d "Set completion date" -r
complete -c remctl -n "__fish_seen_subcommand_from done" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from link" -s l -l list -d "Get links for active reminders in list" -r
complete -c remctl -n "__fish_seen_subcommand_from link" -l list-id -d "Get links for active reminders in list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from link" -l completed -d "Include completed reminders"
complete -c remctl -n "__fish_seen_subcommand_from export" -s l -l list -d "Export only this list" -r
complete -c remctl -n "__fish_seen_subcommand_from export" -l list-id -d "Export only this list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from export" -l format -d "Export format" -a "json csv"
complete -c remctl -n "__fish_seen_subcommand_from list-symbols" -l html -d "Write a standalone HTML preview contact sheet" -r
complete -c remctl -n "__fish_seen_subcommand_from list-symbols" -l preview -d "Generate and open the HTML preview contact sheet"
complete -c remctl -n "__fish_seen_subcommand_from list-create" -l color -d "List color name; with --private also accepts #RRGGBB" -r
complete -c remctl -n "__fish_seen_subcommand_from list-create" -l private -d "Use private ReminderKit list appearance writes"
complete -c remctl -n "__fish_seen_subcommand_from list-create" -l symbol -d "Official Reminders list symbol name" -r
complete -c remctl -n "__fish_seen_subcommand_from list-create" -l emoji -d "Private Reminders list emoji badge" -r
complete -c remctl -n "__fish_seen_subcommand_from list-create" -l groceries -d "Create as a Reminders Groceries list"
complete -c remctl -n "__fish_seen_subcommand_from list-create" -l grocery-locale -d "Groceries locale identifier" -r
complete -c remctl -n "__fish_seen_subcommand_from list-create" -l group -d "Private metadata: create this list inside a group" -r
complete -c remctl -n "__fish_seen_subcommand_from list-create" -l group-id -d "Private metadata: create this list inside a group ID" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create" -l private -d "Use private ReminderKit smart-list creation"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l color -d "Smart-list color name or #RRGGBB" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l symbol -d "Official Reminders list symbol" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l emoji -d "Private Reminders emoji badge" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create" -l flagged -d "Filter to flagged reminders"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create" -l priority -d "Priority filter" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l match -d "Match all or any filters" -a "all any"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l filter-json -d "Raw official filter JSON or @path" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l tags -d "Selected tag filter, comma-separated" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l tag-match -d "Selected tag matching mode" -a "all any"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l any-tag -d "Filter to reminders with any tag"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l date -d "Date filter" -a "any today"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l date-today-include-past-due -d "Include past due with today"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l date-on -d "On date" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l date-before -d "Before date" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l date-after -d "After date" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l date-range -d "Date range START,END" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l time -d "Time filter" -a "morning afternoon evening night"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l include-list -d "Include one list" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l include-list-id -d "Include numeric list ID" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l vehicle -d "Vehicle filter" -a "connected"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l location-title -d "Location title" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l latitude -d "Latitude" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l longitude -d "Longitude" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l radius -d "Radius meters" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-create smart-list-edit" -l proximity -d "Location proximity" -a "enter leave arriving leaving"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-edit" -l private -d "Use private ReminderKit smart-list editing"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-edit" -l smart-list-id -d "Edit by numeric smart-list ID" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-edit" -l flagged -d "Filter to flagged reminders"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-edit" -l priority -d "Priority filter" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-edit" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-delete" -l private -d "Use private ReminderKit smart-list deletion"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-delete" -l smart-list-id -d "Delete by numeric smart-list ID" -r
complete -c remctl -n "__fish_seen_subcommand_from smart-list-delete" -l force -d "Skip confirmation prompt"
complete -c remctl -n "__fish_seen_subcommand_from smart-list-delete" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from templates" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from sharees" -l list-id -d "Shared list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from sharees" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from template-info" -l template-id -d "Read by numeric template ID" -r
complete -c remctl -n "__fish_seen_subcommand_from template-info" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from group-create" -l add-list -d "Move existing list into the new group" -r
complete -c remctl -n "__fish_seen_subcommand_from group-create" -l add-list-id -d "Move existing list by numeric ID into the new group" -r
complete -c remctl -n "__fish_seen_subcommand_from group-create" -l private -d "Use private ReminderKit group creation"
complete -c remctl -n "__fish_seen_subcommand_from group-create" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from group-info" -l group-id -d "Read by numeric group ID" -r
complete -c remctl -n "__fish_seen_subcommand_from group-info" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l group-id -d "Edit group by numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l new-name -d "Rename the group" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l add-list -d "Move existing list into the group" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l add-list-id -d "Move existing list by numeric ID into the group" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l remove-list -d "Move child list out of the group" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l remove-list-id -d "Move child list by numeric ID out of the group" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l move-list -d "Move or reorder a list in this group" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l move-list-id -d "Move or reorder a list by numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l before-list -d "Place moved list before this child list" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l before-list-id -d "Place moved list before this child list ID" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l after-list -d "Place moved list after this child list" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l after-list-id -d "Place moved list after this child list ID" -r
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l first -d "Place moved list first in the group"
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l last -d "Place moved list last in the group"
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l private -d "Use private ReminderKit group editing"
complete -c remctl -n "__fish_seen_subcommand_from group-edit" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from group-delete" -l group-id -d "Delete group by numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from group-delete" -l private -d "Use private ReminderKit group deletion"
complete -c remctl -n "__fish_seen_subcommand_from group-delete" -l force -d "Skip confirmation prompt"
complete -c remctl -n "__fish_seen_subcommand_from group-delete" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from template-create" -l from-list -d "Source list name" -r
complete -c remctl -n "__fish_seen_subcommand_from template-create" -l from-list-id -d "Source list numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from template-create" -l include-completed -d "Include completed reminders"
complete -c remctl -n "__fish_seen_subcommand_from template-create" -l private -d "Use private ReminderKit template creation"
complete -c remctl -n "__fish_seen_subcommand_from template-create" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from template-apply" -l template-id -d "Apply by numeric template ID" -r
complete -c remctl -n "__fish_seen_subcommand_from template-apply" -l private -d "Use private ReminderKit template application"
complete -c remctl -n "__fish_seen_subcommand_from template-apply" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from template-delete" -l template-id -d "Delete by numeric template ID" -r
complete -c remctl -n "__fish_seen_subcommand_from template-delete" -l private -d "Use private ReminderKit template deletion"
complete -c remctl -n "__fish_seen_subcommand_from template-delete" -l force -d "Skip confirmation prompt"
complete -c remctl -n "__fish_seen_subcommand_from template-delete" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from list-edit" -l list-id -d "Edit a list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from list-edit" -l new-name -d "Rename the list through private ReminderKit" -r
complete -c remctl -n "__fish_seen_subcommand_from list-edit" -l color -d "List color name or #RRGGBB" -r
complete -c remctl -n "__fish_seen_subcommand_from list-edit" -l private -d "Required for list appearance writes"
complete -c remctl -n "__fish_seen_subcommand_from list-edit" -l symbol -d "Official Reminders list symbol name" -r
complete -c remctl -n "__fish_seen_subcommand_from list-edit" -l emoji -d "Private Reminders list emoji badge" -r
complete -c remctl -n "__fish_seen_subcommand_from list-edit" -l groceries -d "Convert to a Reminders Groceries list"
complete -c remctl -n "__fish_seen_subcommand_from list-edit" -l standard -d "Convert a Groceries list back to a standard list"
complete -c remctl -n "__fish_seen_subcommand_from list-edit" -l grocery-locale -d "Groceries locale identifier" -r
complete -c remctl -n "__fish_seen_subcommand_from list-pin list-unpin" -l private -d "Use private ReminderKit list pinning"
complete -c remctl -n "__fish_seen_subcommand_from list-pin list-unpin" -l list-id -d "Target list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from list-pin list-unpin" -l smart-list-id -d "Target smart list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from list-pin list-unpin" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from list-rename" -l list-id -d "Rename list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from list-rename" -l new-name -d "New list name" -r
complete -c remctl -n "__fish_seen_subcommand_from list-delete" -l list-id -d "Delete list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from list-delete" -l force -d "Skip confirmation prompt"
complete -c remctl -n "__fish_seen_subcommand_from section-create" -s l -l list -d "Target list" -r
complete -c remctl -n "__fish_seen_subcommand_from section-create" -l list-id -d "Target list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from section-create" -l private -d "Use private ReminderKit section creation"
complete -c remctl -n "__fish_seen_subcommand_from section-create" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from section-rename" -l new-name -d "New section name" -r
complete -c remctl -n "__fish_seen_subcommand_from section-rename" -s l -l list -d "Section list" -r
complete -c remctl -n "__fish_seen_subcommand_from section-rename" -l list-id -d "Section list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from section-rename" -l section-id -d "Target section by stable ID" -r
complete -c remctl -n "__fish_seen_subcommand_from section-rename" -l private -d "Use private ReminderKit section renaming"
complete -c remctl -n "__fish_seen_subcommand_from section-rename" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from section-delete" -s l -l list -d "Section list" -r
complete -c remctl -n "__fish_seen_subcommand_from section-delete" -l list-id -d "Section list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from section-delete" -l section-id -d "Target section by stable ID" -r
complete -c remctl -n "__fish_seen_subcommand_from section-delete" -l force -d "Skip confirmation prompt"
complete -c remctl -n "__fish_seen_subcommand_from section-delete" -l private -d "Use private ReminderKit section deletion"
complete -c remctl -n "__fish_seen_subcommand_from section-delete" -l json -d "JSON output"
complete -c remctl -n "__fish_seen_subcommand_from add" -l private -d "Use unsupported private ReminderKit metadata writes"
complete -c remctl -n "__fish_seen_subcommand_from add" -l section -d "Assign to existing section" -r
complete -c remctl -n "__fish_seen_subcommand_from add" -l section-id -d "Assign to section by stable ID" -r
complete -c remctl -n "__fish_seen_subcommand_from add" -l new-section -d "Create and assign to new section" -r
complete -c remctl -n "__fish_seen_subcommand_from add" -l subtask -d "Add private subtask title or JSON object" -r
complete -c remctl -n "__fish_seen_subcommand_from add" -l image -d "Add private image attachment" -r
complete -c remctl -n "__fish_seen_subcommand_from add" -l assign -d "Assign to shared-list user" -r
complete -c remctl -n "__fish_seen_subcommand_from add" -l unassign -d "Clear existing assignment"
complete -c remctl -n "__fish_seen_subcommand_from add" -l grocery -d "Auto-categorize in a Groceries list"
complete -c remctl -n "__fish_seen_subcommand_from add" -l urgent -d "Set private urgent state"
complete -c remctl -n "__fish_seen_subcommand_from add" -l no-urgent -d "Clear private urgent state"
complete -c remctl -n "__fish_seen_subcommand_from add" -l early-reminder -d "Set Early Reminder delta, e.g. 15m, 1h, clear" -r
complete -c remctl -n "__fish_seen_subcommand_from add" -l url -d "URL, web rich link with --private" -r
complete -c remctl -n "__fish_seen_subcommand_from add" -s t -l tags -d "Tags, synced with --private" -r
complete -c remctl -n "__fish_seen_subcommand_from add" -l list-id -d "Target list by stable numeric ID" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l private -d "Use unsupported private ReminderKit metadata writes"
complete -c remctl -n "__fish_seen_subcommand_from edit" -l section -d "Assign to existing section" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l section-id -d "Assign to section by stable ID" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l new-section -d "Create and assign to new section" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l subtask -d "Add private subtask title or JSON object" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l image -d "Add private image attachment" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l assign -d "Assign to shared-list user" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l unassign -d "Clear existing assignment"
complete -c remctl -n "__fish_seen_subcommand_from edit" -l grocery -d "Auto-categorize in the reminder Groceries list"
complete -c remctl -n "__fish_seen_subcommand_from edit" -l flagged -d "Set real private flag"
complete -c remctl -n "__fish_seen_subcommand_from edit" -l no-flagged -d "Clear real private flag"
complete -c remctl -n "__fish_seen_subcommand_from edit" -l urgent -d "Set private urgent state"
complete -c remctl -n "__fish_seen_subcommand_from edit" -l no-urgent -d "Clear private urgent state"
complete -c remctl -n "__fish_seen_subcommand_from edit" -l early-reminder -d "Set Early Reminder delta, e.g. 15m, 1h, clear" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l location-title -d "Location alarm title" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l latitude -d "Location alarm latitude" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l longitude -d "Location alarm longitude" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l radius -d "Location alarm radius" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l proximity -d "Location trigger" -a "arriving leaving"
complete -c remctl -n "__fish_seen_subcommand_from edit" -s l -l list -d "Move to list; pure moves may return new id" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l list-id -d "Move to list by stable numeric ID; pure moves may return new id" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -s t -l tags -d "Synced tags with --private" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l set-tags -d "Replace all synced tags with --private" -r
complete -c remctl -n "__fish_seen_subcommand_from edit" -l clear-tags -d "Remove all synced tags with --private"
complete -c remctl -n "__fish_seen_subcommand_from edit" -l remove-tag -d "Remove one synced tag with --private" -r
