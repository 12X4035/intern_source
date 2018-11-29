<?php
use yii\helpers\Html;
use yii\bootstrap\ActiveForm;
use yii\base\view;
function formatDateTime($datetime)
{
    $datetime=strtotime($datetime);
    $yesterday=strtotime(date('Y-m-d', mktime(0,0,0, date("m") , date("d") - 1, date("Y"))));
    $tomorrow=strtotime(date('Y-m-d', mktime(0,0,0, date("m") , date("d") + 1, date("Y"))));
    $time=strftime('%H:%M',$datetime);
    $date=strftime('%e %b %Y',$datetime);

    if($date==strftime('%e %b %Y',strtotime(date('Y-m-d'))))
    {
        $date="Today";
    }
    elseif($date==strftime('%e %b %Y',$yesterday))
    {
        $date="Yesterday";
    }
    elseif($date==strftime('%e %b %Y',$tomorrow))
    {
        $date="Tomorrow";
    }

    return $date." at ".$time;
}
 ?>

<div class="wrapper">
    <?= $this->render('/common/sidebar');?>
    <div id="content">
	<div class="wrap-setting">
	
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#send_token_popup">
                    <span>Send Token</span>
                </button><br><br>
      	</div>
    </div>
</div>

<div class="modal fade send_token_popup" id="send_token_popup">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<a href="#" data-dismiss="modal" class="class pull-right"><span class="glyphicon glyphicon-remove"></span></a>
				<h3>Send Token</h3>
			</div>
			<div class="modal-body">
                <div class="alert alert-success alert-dismissable" style="display: none;">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                    <span>Success</span>
                </div>
                <div class="alert alert-danger alert-dismissable" style="display: none;">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                    <span>Oh snap! Need to create account.</span>
                </div>
                <div class="row" style="margin-bottom: 20px;">
			<div class="col-sm-6 col-sm-offset-3">

			<!--Not Shure-->
	
			<label class="control-label" for="text">Address</label>
                        <input type="text" id="fromAddress" class="form-control" name="fromAddress" value="" placeholder="From" required="required">
                        <input type="hidden" id="fromAddress" value="">

			<label class="control-label" for="text">Address</label>
                        <input type="text" id="toAddress" class="form-control" name="toAddress" value="" placeholder="To" required="required">
                        <input type="hidden" id="toAddress" value="">

                        <label class="control-label" for="password">Input password</label>
                        <input type="password" id="accountPassword" class="form-control" name="account-password" value="" placeholder="Password" required="required">
                        <input type="hidden" id="toAddress" value="">
			</div>
                </div>
				<div class="row">
					<div class="col-sm-6 col-sm-offset-3 text-center">
					<form class="form-inline" role="search">
						<div class="form-group">
							<label>Send: </label>
							<input id="giveTokenAmount" type="number" class="form-control" placeholder="100" value="1" style="width: 100px; text-align: center;">
							<span>HDO</span>
						</div>
						<button type="button" id="sendTokenBtn" class="btn btn-primary btn-lg" data-loading-text="<i class='fa fa-circle-o-notch fa-spin'></i> Sending...">Send</button>
					</form>
					</div>
                </div>
			</div>
		</div>
	</div>
</div>

