if Meteor.isClient
    Template.nav.events
        'click #logout': -> 
            AccountsTemplates.logout()
    
    Template.body.events
        'click .toggle_sidebar': ->
            $('.ui.sidebar').sidebar('toggle')
        
    Template.nav.onCreated ->
        @autorun -> 
            Meteor.subscribe 'me'
        


if Meteor.isServer
    Meteor.publish 'me', ->
        Meteor.users.find @userId,
            fields: 
                courses: 1
