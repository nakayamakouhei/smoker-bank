class HistorySummary
  DEFAULT_PER_PAGE = 10

  attr_reader :user, :params

  def initialize(user:, params: {})
    @user = user
    raw_params = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params
    @params = raw_params.to_h.with_indifferent_access
  end

  def paginated_histories
    @paginated_histories ||= Kaminari.paginate_array(filtered_histories)
      .page(params[:page])
      .per(params[:per].presence || DEFAULT_PER_PAGE)
  end

  def filtered_total_amount
    totals[:amount]
  end

  def filtered_total_packs
    totals[:packs]
  end

  def filtered_histories
    @filtered_histories ||= begin
      histories = base_histories
      histories = apply_sort(histories)
      histories = apply_date_filter(histories)
      histories
    end
  end

  private

  def totals
    @totals ||= begin
      amount = filtered_histories.sum do |log|
        log_amount(log)
      end
      packs = filtered_histories.sum(&:packs)
      { amount: amount, packs: packs }
    end
  end

  def base_histories
    smokes = user.smokes.includes(:cigarette).to_a
    custom_logs = user.custom_cigarette_logs.includes(:custom_cigarette).to_a
    smokes + custom_logs
  end

  def apply_sort(histories)
    case params[:sort]
    when "date_asc"
      histories.sort_by(&:bought_date)
    when "name_asc"
      histories.sort_by { |log| log_name(log) }
    when "price_desc"
      histories.sort_by { |log| log_price(log) }.reverse
    when "price_asc"
      histories.sort_by { |log| log_price(log) }
    else
      histories.sort_by(&:bought_date).reverse
    end
  end

  def apply_date_filter(histories)
    return histories unless params[:start_date].present? && params[:end_date].present?

    start_date = parse_date(params[:start_date])
    end_date = parse_date(params[:end_date])
    return histories unless start_date && end_date

    histories.select { |log| log.bought_date.between?(start_date, end_date) }
  end

  def parse_date(value)
    Date.parse(value)
  rescue ArgumentError, TypeError
    nil
  end

  def log_amount(log)
    price = log_price(log)
    price * log.packs
  end

  def log_price(log)
    if log.is_a?(Smoke)
      log.cigarette.price
    else
      log.custom_cigarette.price
    end
  end

  def log_name(log)
    if log.is_a?(Smoke)
      log.cigarette.name
    else
      log.custom_cigarette.name
    end
  end
end
