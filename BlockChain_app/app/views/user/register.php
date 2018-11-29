<?php
use yii\helpers\Html;
use yii\bootstrap\ActiveForm;
?>
<div class="container wrap-form-login">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="panel panel-login">
                <div class="panel-heading">
                    <div class="row">
                        <div class="col-xs-6">
                            <?= Html::a('Login', ['user/login']) ?>
                        </div>
                        <div class="col-xs-6">
                            <?= Html::a('Register', ['register'], ['class' => 'active']) ?>
                        </div>
                    </div>
                    <hr>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-12">
                            <?php $form = ActiveForm::begin(['action' => ['user/register'], 'id' => 'form-register', 'method' => 'POST']); ?>
                                <?= $form->field($model, 'mail_address')->textInput(['class' => 'form-control', 'placeholder' => 'Email', 'autofocus' => true]) ?>
                                <?= $form->field($model, 'password')->passwordInput(['class' => 'form-control', 'placeholder' => 'Password']) ?>
                                <?= $form->field($model, 'confirm_password')->passwordInput(['class' => 'form-control', 'placeholder' => 'Confirm Password']) ?>
                            <div class="form-group">
                                <div class="row"><div class="col-sm-2 col-sm-offset-5 text-center">
                                <?= Html::submitButton('REGISTER', ['class' => 'btn btn-primary', 'name' => 'register-button']) ?></div></div>
                            </div>

                            <?php ActiveForm::end(); ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
