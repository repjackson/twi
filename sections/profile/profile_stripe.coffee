if Meteor.isClient
    Template.profile_stripe.events
        'click #connect': ->
            FlowRouter.go("https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_6xrceWlIdjoZ0ebtxSUDBMG1yazAn5et&scope=read_write")
