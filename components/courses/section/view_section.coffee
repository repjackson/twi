if Meteor.isClient    
    FlowRouter.route '/course/sol/module/:module_number/section/:section_number', 
        name:'doc_section'
        action: (params) ->
            BlazeLayout.render 'doc_section'
    
    
    
    Template.doc_section.onCreated ->
        Session.setDefault('module_number', parseInt(FlowRouter.getParam('module_number')))
        Session.setDefault('section_number', parseInt(FlowRouter.getParam('section_number')))
        # module_num = parseInt FlowRouter.getParam('module_number')
        # section_num = parseInt FlowRouter.getParam('section_number')
        @autorun -> Meteor.subscribe 'module', parseInt(Session.get('module_number'))
        @autorun -> Meteor.subscribe 'sections', parseInt(Session.get('module_number'))
        @autorun -> Meteor.subscribe 'section_content', parseInt(Session.get('module_number')), parseInt(Session.get('section_number'))
        @autorun -> Meteor.subscribe 'section_transcript', parseInt(Session.get('module_number')), parseInt(Session.get('section_number'))
        @autorun -> Meteor.subscribe 'section', parseInt(Session.get('module_number')), parseInt(Session.get('section_number'))
        @autorun -> Meteor.subscribe 'section_progress_doc', parseInt(Session.get('module_number')), parseInt(Session.get('section_number'))
        @autorun -> Meteor.subscribe 'reflective_questions', parseInt(Session.get('module_number')), parseInt(Session.get('section_number'))
        


    Template.doc_section.onRendered ->
        self = @
        
        @autorun =>
            # console.log Session.get 'section_number'
            # if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()            
                mod_num = Session.get('module_number')
                sec_num = Session.get('section_number')

                section_progress_doc =  Docs.findOne(tags: $all: ["section progress","module #{mod_num}", "section #{sec_num}"])
                # console.log section_progress_doc
                $('#section_percent_complete_bar').progress(
                    percent: section_progress_doc.percent_complete
                    autoSuccess: false
                    );
            , 1000

    
    Template.doc_section.helpers
        module_number: -> FlowRouter.getParam('module_number')
    
        title_tags: -> "sol,module #{FlowRouter.getParam('module_number')},title"
    
        section_content_tags: ->
            mod_num = Session.get('module_number')
            sec_num = Session.get('section_number')
            "sol,module #{mod_num},section #{sec_num},content"
        section_transcript_tags: ->
            mod_num = Session.get('module_number')
            sec_num = Session.get('section_number')

            "sol,module #{FlowRouter.getParam('module_number')},section #{FlowRouter.getParam('section_number')},transcript"

        section_progress_doc: ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')
            Docs.findOne
                tags: ['sol', "module #{module_num}", "section #{section_num}", 'section progress']
                author_id: Meteor.userId()

        video_complete: ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')

            section_progress_doc = Docs.findOne
                tags: $all: ['sol', "module #{module_num}", "section #{section_num}", 'section progress']
                author_id: Meteor.userId()
            section_progress_doc?.video_complete
    
        reflective_question_docs: -> 
            mod_num = FlowRouter.getParam('module_number')
            sec_num = FlowRouter.getParam('section_number')
            Docs.find {
                tags: ["sol","module #{mod_num}","section #{sec_num}","reflective question"] }
                , { sort: number: 1} 
                
        any_reflective_questions: ->
            mod_num = FlowRouter.getParam('module_number')
            sec_num = FlowRouter.getParam('section_number')
            Docs.find({
                tags: ["sol","module #{mod_num}","section #{sec_num}","reflective question"] }).count()

        reflective_question_answered: ->
            found_answer = Docs.findOne
                tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()

            if found_answer
                # console.log "has answered question #{@number}"
                return true
            else
                # console.log "has NOT answered question #{@number}"
                return false
                
                
        all_questions_answered: ->
            mod_num = FlowRouter.getParam('module_number')
            sec_num = FlowRouter.getParam('section_number')
            question_count = Docs.find({tags: ["sol","module #{mod_num}","section #{sec_num}","reflective question"] }).count()
            answer_count = 
                Docs.find( 
                    tags: $all: ["sol","module #{mod_num}","section #{sec_num}","reflective question",'answer']
                    author_id:Meteor.userId()).count()
            # console.log question_count
            # console.log answer_count
            question_count is answer_count    
                
        module: -> 
            module_num = parseInt FlowRouter.getParam('module_number')
            Docs.findOne 
                tags: $in: ['module']
                number: module_num

        section: -> 
            section_number = parseInt(FlowRouter.getParam('section_number'))

            section = Docs.findOne 
                tags: $in: ['section']
                number: section_number
            # console.log section_number
            section
            
        previous_section: ->
            section_number = parseInt(FlowRouter.getParam('section_number'))
            module_num = parseInt FlowRouter.getParam('module_number')

            previous_section_number = section_number - 1
            Docs.findOne
                tags: ['section']
                module_number: module_num
                number: previous_section_number
                
        next_section: ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_number = parseInt(FlowRouter.getParam('section_number'))
            next_section_number = section_number + 1
            Docs.findOne
                tags: ['section']
                module_number: module_num
                number: next_section_number
                
        section_complete: ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')
            section_progress_doc = 
                Docs.findOne
                    tags: $all: ['sol', "module #{module_num}", "section #{section_num}", 'section progress']
                    author_id: Meteor.userId()
            section_progress_doc?.percent_complete is 100
    
        next_section_number: -> 
            parseInt(FlowRouter.getParam('section_number')) + 1
    
        next_section_exists: ->
            next_section_number = parseInt(FlowRouter.getParam('section_number')) + 1
            module_number = parseInt FlowRouter.getParam('module_number')

            next_section_doc = 
                Docs.findOne
                    tags: ['section']
                    number: next_section_number
                    module_number: module_number
            if next_section_doc then true else false
                    
                
        is_editing: -> Session.get 'editing_id'    
    Template.doc_section.events
        'click .edit': ->
            module_number = FlowRouter.getParam('module_number')
            course_slug = FlowRouter.getParam('course_slug')
            FlowRouter.go "/course/#{course_slug}/module/#{@_id}/edit"
            
            
        'click .mark_video_complete': ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')
            
            Meteor.call 'toggle_video_complete', module_num, section_num, true

            Meteor.call 'calculate_section_progress', module_num, section_num, (err,res)->
                # console.log res
                $('#section_percent_complete_bar').progress('set percent', res);
                # console.log $('#section_percent_complete_bar').progress('get percent');

    
        'click .unmark_video_complete': ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')

            Meteor.call 'toggle_video_complete', module_num, section_num, false
            
            Meteor.call 'calculate_section_progress', module_num, section_num, (err,res)->
                # console.log res
                $('#section_percent_complete_bar').progress('set percent', res);
                # console.log $('#section_percent_complete_bar').progress('get percent');

        'click #go_to_previous_section': ->
            current_section_number = parseInt FlowRouter.getParam('section_number')
            previous_section_number = current_section_number - 1
            $('#section_percent_complete_bar').progress('reset');
            Session.set 'section_number', previous_section_number
            FlowRouter.setParams({section_number: previous_section_number})
            Meteor.setTimeout ->
                section_progress_doc =  Docs.findOne(tags: $in: ["section progress"])
                # console.log section_progress_doc
                $('#section_percent_complete_bar').progress(
                    percent: section_progress_doc.percent_complete
                    );
            , 1000

            
        'click .go_to_next_section': ->
            current_section_number = parseInt FlowRouter.getParam('section_number')
            next_section_number = current_section_number + 1
            Session.set 'section_number', next_section_number
            # $('#section_percent_complete_bar').progress('reset');
            FlowRouter.setParams({section_number: next_section_number})
            Meteor.setTimeout ->
                section_progress_doc =  Docs.findOne(tags: $in: ["section progress"])
                # console.log section_progress_doc
                $('#section_percent_complete_bar').progress(
                    percent: section_progress_doc.percent_complete
                    );
            , 1000



        'click #mark_section_complete': ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')

            Meteor.call 'calculate_section_progress', module_num, section_num, (err,res)->
                # console.log res
                $('#section_percent_complete_bar').progress('set percent', res);
                # console.log $('#section_percent_complete_bar').progress('get percent');

    
if Meteor.isServer
    Meteor.publish 'section', (module_number, section_number)->
        
        Docs.find
            tags: $in: ['section']
            module_number: module_number
            number: section_number
            
    # publishComposite 'section', (module_number, section_number)->
    #     {
    #         find: ->
    #             Docs.find
    #                 tags: $in: ['section']
    #                 module_number: module_number
    #                 number: section_number
    #         children: [
    #             { find: (section) ->
    #                 Docs.find 
    #                     tags: $all: ['sol', "module #{module_number}", "section #{section_number}","content"]
    #                 }
    #             ]    
    #     }
            
            
            
            
            
    Meteor.publish 'section_content', (module_number, section_number)->
        Docs.find
            tags: $all: ['sol', "module #{module_number}", "section #{section_number}", "content"]
                # tags: $all: ['sol', "module #{module_number}", "section #{section_number}", "transcript"]
    
    Meteor.publish 'section_transcript', (module_number, section_number)->
        Docs.find
            tags: $all: ['sol', "module #{module_number}", "section #{section_number}", "transcript"]
    
            
            
    Meteor.publish 'section_progress_doc', (module_number, section_number)->
        Docs.find
            tags: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']
            author_id: @userId
        
        
    Meteor.methods 
        'toggle_video_complete': (module_number, section_number, boolean)->    
            Docs.update { 
                    tags: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']
                    author_id: Meteor.userId() 
                },
                { $set: video_complete: boolean },
                { upsert: true }
            section_progress_doc = 
                Docs.findOne
                    tags: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']
                    author_id: Meteor.userId()

            # console.log 'first found progress doc', section_progress_doc
            

            # Meteor.call 'calculate_section_progress', module_number, section_number
    
    
    
    
        'calculate_section_progress': (module_number, section_number)->
            # console.log module_number
            # console.log section_number
            section_progress_doc = 
                Docs.findOne
                    tags: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']
                    author_id: Meteor.userId()
        
            # console.log 'second found progress doc', section_progress_doc
            
            
            section_question_count = 
                Docs.find( 
                    tags: $all: ['sol', "module #{module_number}", "section #{section_number}", 'reflective question']
                    tag_count: 4
                ).count()
        
        
            section_answer_count = 
                Docs.find( 
                    tags: $all: ['sol', "module #{module_number}", "section #{section_number}", 'reflective question','answer']
                    author_id: Meteor.userId()
                ).count()
                
            # console.log 'question count',section_question_count
            # console.log 'answer count',section_answer_count
            
            found_answers = Docs.find( 
                    tags: $all: ['sol', "module #{module_number}", "section #{section_number}", 'reflective question','answer']
                    author_id: Meteor.userId()
                ).fetch()
            # console.log 'found_answers', found_answers

            # section_progress_doc = 
            #     Docs.findOne
            #         tags: $all: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']


            # if not section_progress_doc
            #     new_progress_doc_id = 
            #         Docs.insert
            #             percent_complete: 0
            #             tags: ["sol", "module #{module_number}", "section #{section_number}", "section progress"]
            #             questions_complete: 0
            #             section_question_count: section_question_count
            #     console.log 'new progress doc id', new_progress_doc_id
            
            section_progress_doc = 
                Docs.findOne
                    tags: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']
                    author_id: Meteor.userId()

            # if section_progress_doc then console.log 'found' else console.log 'not'

            if section_question_count is section_answer_count
                questions_complete = true
                # console.log 'questions complete'
            else
                questions_complete = false
                # console.log 'questions not complete'
                
                
            Docs.update section_progress_doc._id,
                $set: 
                    section_question_count: section_question_count
                    section_answer_count: section_answer_count
                    questions_complete: questions_complete
            
            # console.log section_progress_doc
    
                
            if section_progress_doc.video_complete
                if section_question_count is 0    
                    Docs.update section_progress_doc._id,$set:percent_complete: 100
                    Meteor.call 'calculate_module_progress', module_number
                    return 100
                else if questions_complete is false
                    Docs.update section_progress_doc._id,$set:percent_complete: 50
                    Meteor.call 'calculate_module_progress', module_number
                    return 50
                else if questions_complete is true
                    Docs.update section_progress_doc._id,$set:percent_complete: 100
                    Meteor.call 'calculate_module_progress', module_number
                    return 100
                    
            else
                Docs.update section_progress_doc._id,$set:video_complete: false
                if section_question_count is 0    
                    Docs.update section_progress_doc._id,$set:percent_complete: 0
                    Meteor.call 'calculate_module_progress', module_number
                    return 0
                else
                    Meteor.call 'calculate_module_progress', module_number
                    return 0