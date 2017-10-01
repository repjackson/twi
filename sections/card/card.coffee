if Meteor.isClient
    Template.card.helpers
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    
    
        five_tags: -> if @tags then @tags[..4]
    
    Template.card.events
        'click .person_tag': ->
            if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove @valueOf() else selected_theme_tags.push @valueOf()
    
    
        'click .check_in': ->
            Meteor.users.update @_id,
                $set: checked_in: true
    
        'click .check_out': ->
            Meteor.users.update @_id,
                $set: checked_in: false
    
    
    
