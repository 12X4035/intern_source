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
		<div class="clearfix wrap-add-post">
            <?php $form = ActiveForm::begin(['action' => ['add'], 'id' => 'post-form', 'method' => 'POST']); ?>
                <div class="form-group">
                    <?= $form->field($model, 'content')->textarea(['class' => 'form-control textarea', 'rows' => 3, 'placeholder' => "What`s happening"]) ?>
                </div>	
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                        <div class="pull-right">
                            <?= Html::submitButton('Post', ['class' => 'btn btn-primary', 'name' => 'post-button']) ?></div>
                        <?php if (Yii::$app->session->hasFlash('postSubmitted')) { ?>
                            <div class="pull-right">
                                <div class="alert alert-success alert-dismissable"  style="font-size: 10px; margin: 5px 10px 0 0; padding: 0px 22px 0 5px;">
                                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                    <strong>Well done!</strong> Save successful
                                </div>
                            </div>
                        <?php } ?>
                    </div>
                </div>
                <?php ActiveForm::end(); ?>
		</div>
		<div class="wrap-post-list">
			<ul>
                <?php
                foreach ($posts as $post) {
                ?>
                <li><div class="clearfix p-content">
                        <div class="p-item-header">
                            <a><strong class="p-fullname"><?= ($post->user->nickname) ? $post->user->nickname : 'No name'; ?></strong></a>
                            <small class="p-time"><span class="" aria-hidden="true"><?= formatDateTime($post->created_at); ?></span></small>
                        </div>
                        <p class="p-content"><?= $post->content; ?></p>
                        <div class="col-sm-offset-2 col-sm-10">
                            <?php if ($post->user->personaladdress && ($post->user_id != Yii::$app->user->identity->user_id) && (Yii::$app->user->identity->personaladdress)) { ?>
                                <input type="hidden" id="userAddress" value="<?= $post->user->personaladdress ?>">
                                <div class="pull-right"><div class="specialities"><a class="p-like open-sendTokenDialog" data-address="<?= $post->user->personaladdress ?>" data-toggle="modal" data-target="#send_token_popup"><span>Like</span></a></div></div>
                            <?php } ?>
                        </div>
                    </div></li>
            <?php } ?>
			</ul>
		</div>
    </div>
</div>

<div class="modal fade send_token_popup" id="send_token_popup">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<a href="#" data-dismiss="modal" class="class pull-right"><span class="glyphicon glyphicon-remove"></span></a>
				<h3>Gift Token</h3>
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
