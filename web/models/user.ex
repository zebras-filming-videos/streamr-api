defmodule Streamr.User do
  use Streamr.Web, :model
  alias Streamr.{User, UserSubscription}

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :streams, Streamr.Stream
    has_many :comment, Streamr.Comment, on_delete: :delete_all

    has_many :_subscriptions, Streamr.UserSubscription, foreign_key: :subscriber_id
    has_many :subscribers, through: [:_subscriptions, :subscriber_id]

    has_many :_subscribers, Streamr.UserSubscription, foreign_key: :subscription_id
    has_many :subscriptions,
      through: [:_subscribers, :subscription_id],
      foreign_key: :subscription_id

    timestamps()
  end

  def subscriptions(user) do
    from u in User,
    join: s in UserSubscription,
    on: s.subscriber_id == u.id,
    where: u.id == ^user.id
  end

  def subscribed_to(user) do
    from u in User,
    join: s in UserSubscription,
    on: s.subscription_id == u.id,
    where: u.id == ^user.id
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:email, min: 1, max: 254)
    |> validate_email_uniqueness
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> put_pass_hash()
  end

  def find_and_confirm_password(email, password) do
    user = Streamr.Repo.get_by(Streamr.User, email: email)

    cond do
      user && Comeonin.Bcrypt.checkpw(password, user.password_hash) ->
        {:ok, user}
      true ->
        Comeonin.Bcrypt.dummy_checkpw()
        {:error, nil}
    end
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp validate_email_uniqueness(changeset) do
    validate_change changeset, :email, fn _field, email ->
      user = Streamr.Repo.get_by(Streamr.User, email: email || "")

      if is_nil(user) do
        []
      else
        [{:email, "is invalid"}]
      end
    end
  end
end
