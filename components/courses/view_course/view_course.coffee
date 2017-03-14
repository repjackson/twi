FlowRouter.route '/course/view/:course_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_course'


if Meteor.isClient
    Template.view_course.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'course', FlowRouter.getParam('course_id')
    
    Template.buy_course.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
        Template.instance().checkout = StripeCheckout.configure(
            key: Meteor.settings.public.stripe.testPublishableKey
            # image: 'https://tmc-post-content.s3.amazonaws.com/ghostbusters-logo.png'
            locale: 'auto'
            # zipCode: true
            token: (token) ->
                # console.log token
                # product = Docs.findOne FlowRouter.getParam('doc_id')
                # console.log product
                charge = 
                    amount: 10000
                    currency: 'usd'
                    source: token.id
                    description: token.description
                    receipt_email: token.email
                Meteor.call 'processPayment', charge, (error, response) ->
                    if error then Bert.alert error.reason, 'danger'
                    else
                        Meteor.users.update Meteor.userId(),
                            $addToSet: courses: 'sol'
                        Bert.alert 'Thanks for your payment.', 'success'
                        FlowRouter.go "/profile/edit/#{Meteor.userId()}"
            # closed: ->
            #     alert 'closed'

              # We'll pass our token and purchase info to the server here.
        )


    
    Template.view_course.helpers
        course: ->
            Courses.findOne FlowRouter.getParam('course_id')
        
        in_course: ->
            Meteor.user()?.courses and @title in Meteor.user().courses
    
    
    Template.buy_course.helpers
        course: ->
            Courses.findOne FlowRouter.getParam('course_id')
    
    Template.buy_course.events
        'click .buy_course': ->
            if Meteor.userId() 
                Template.instance().checkout.open
                    name: 'Source of Light'
                    # description: @description
                    amount: @price*100
                    bitcoin: true
            else FlowRouter.go '/sign-in'
    

    
    Template.view_course.events
        'click #mark_as_complete': ->
            Courses.update FlowRouter.getParam('course_id'),
                $set: complete: true
            
        'click #mark_as_incomplete': ->
            Courses.update FlowRouter.getParam('course_id'),
                $set: complete: false
    
        'click .edit': ->
            course_id = FlowRouter.getParam('course_id')
            FlowRouter.go "/course/edit/#{course_id}"


