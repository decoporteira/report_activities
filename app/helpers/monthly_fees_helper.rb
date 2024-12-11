module MonthlyFeesHelper
  def statuses
    {
      'Paga' => {
        text: 'Paga',
        css_class: 'btn btn-outline-primary btn-sm mx-1'
      },
      'A pagar' => {
        text: 'A pagar',
        css_class: 'btn btn-outline-secondary btn-sm mx-1'
      },
      'Atrasada' => {
        text: 'Atrasada',
        css_class: 'btn btn-outline-danger btn-sm mx-1'
      }
    }
  end
end
