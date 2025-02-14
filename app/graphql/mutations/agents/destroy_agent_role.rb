module Mutations
  module Agents
    class DestroyAgentRole < Mutations::BaseMutation
      field :agent, Types::AgentType, null: false
      argument :app_key, String, required: true
      argument :id, String, required: true

      def resolve(app_key:, id:)
        app = current_user.apps.find_by(key: app_key)

        role = app.roles.find_by(id: id)

        agent = role&.agent

        authorize! agent, to: :can_manage_team?, with: AppPolicy, context: {
          app: app
        }

        agent.destroy

        track_resource_event(agent, :agent_destroy, {}, app.id)

        { agent: agent }
      end

      def current_user
        context[:current_user]
      end
    end
  end
end
