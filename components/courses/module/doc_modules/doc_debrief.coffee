if Meteor.isClient
    FlowRouter.route '/course/sol/:module_number/debrief', 
        name: 'doc_debrief'
        action: (params) ->
            BlazeLayout.render 'doc_module',
                module_content: 'doc_debrief'
        
    
    Template.doc_debrief.onCreated ->
        @autorun -> Meteor.subscribe 'debrief_questions', FlowRouter.getParam('module_number')
    
    # Template.answers.onCreated ->
        # @autorun => Meteor.subscribe 'answers', @data._id
    
    

    
    
    Template.doc_debrief.helpers
        debrief_questions: -> 
            Docs.find
                tags: ["sol","module #{FlowRouter.getParam('module_number')}", "debrief","question"]
                
        # debrief_questions_tags: ->
        #     "sol,module #{FlowRouter.getParam('module_number')},debrief,question"
    
    
        has_answered_question: ->
            Docs.findOne
                tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()

    
    Template.answers.helpers
        all_answers: ->
            Docs.find
                parent_id: @_id
                tags: $in: ["answer"]
                published: true
                
        my_answer: ->
            Docs.findOne
                parent_id: @_id
                tags: $in: ["answer"]
                author_id: Meteor.userId()
                
        is_editing_my_answer: ->
            my_answer =             
                Docs.findOne
                    parent_id: @_id
                    tags: $in: ["answer"]
                    author_id: Meteor.userId()
            Session.equals 'editing_id', my_answer._id

    Template.answers.events
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
            
    
    
    
    Template.doc_debrief.events
        'click #add_debrief_question': ->
            Docs.insert
                tags: ["sol","module #{FlowRouter.getParam('module_number')}", "debrief","question"]

        'click .add_debrief_answer': ->
            answer_tags = @tags
            answer_tags.push 'answer'
            # console.log 'answer tags', answer_tags
            new_id = Docs.insert
                tags: answer_tags
                parent_id: @_id
            Session.set 'editing_id', new_id

if Meteor.isServer
    publishComposite 'debrief_questions', (module_number)->
        {
            find: ->
                Docs.find 
                    tags: ["sol","module #{module_number}", "debrief","question"]
            children: [
                { 
                    find: (question) ->
                        Docs.find
                            tags: $in: ["answer"]
                            parent_id: question._id
                    children: [
                        find: (answer) ->
                            Meteor.users.find
                                _id: answer.author_id
                        ]
                }
            ]
        }    
    
    # Meteor.publish 'answers', (parent_id)->
    #     # console.log parent_id
    #     Docs.find 